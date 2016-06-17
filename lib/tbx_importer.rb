require 'tbx_importer/version'
require 'xml'
require 'open-uri'
require 'pretty_strings'
require 'charlock_holmes'

module TbxImporter
  class Tbx
    attr_reader :file_path, :encoding
    def initialize(file_path:, **args)
      @file_path = file_path
      @content = File.read(open(@file_path)) if !args[:encoding].eql?('UTF-8')
      if args[:encoding].nil?
        @encoding = CharlockHolmes::EncodingDetector.detect(@content[0..100_000])[:encoding]
        if @encoding.nil?
          encoding_in_file = @content.dup.force_encoding('utf-8').scrub!("*").gsub!(/\0/, '').scan(/(?<=encoding=").*(?=")/)[0].upcase
          if encoding_in_file.eql?('UTF-8')
            @encoding = ('UTF-8')
          elsif encoding_in_file.eql?('UTF-16')
            @encoding = ('UTF-16LE')
          end
        end
      else
        @encoding = args[:encoding].upcase
      end
      @doc = {
        source_language: "",
        tc: { id: "", counter: 0, vals: [], lang: "", definition: "" },
        term: { lang: "", counter: 0, vals: [], part_of_speech: "", term: "" },
        language_pairs: [],
        term_entry: false
      }
      raise "Encoding type could not be determined. Please set an encoding of UTF-8, UTF-16LE, or UTF-16BE" if @encoding.nil?
      raise "Encoding type not supported. Please choose an encoding of UTF-8, UTF-16LE, or UTF-16BE" unless @encoding.eql?('UTF-8') || @encoding.eql?('UTF-16LE') || @encoding.eql?('UTF-16BE')
      @text = CharlockHolmes::Converter.convert(@content, @encoding, 'UTF-8') if !@encoding.eql?('UTF-8')
    end

    def stats
      if encoding.eql?('UTF-8')
        analyze_stats_utf_8
      else
        analyze_stats_utf_16
      end
      {tc_count: @doc[:tc][:counter], term_count: @doc[:term][:counter], language_pairs: @doc[:language_pairs].uniq}
    end

    def import
      reader = read_file
      parse_file(reader)
      [@doc[:tc][:vals], @doc[:term][:vals]]
    end

    private

    def analyze_stats_utf_8
      File.readlines(@file_path).each do |line|
        analyze_line(line)
      end
    end

    def analyze_stats_utf_16
      @text.each_line do |line|
        analyze_line(line)
      end
    end

    def read_file
      if encoding.eql?('UTF-8')
        XML::Reader.io(open(file_path), options: XML::Parser::Options::NOERROR, encoding: XML::Encoding::UTF_8)
      else
        reader = @text.gsub(/(?<=encoding=").*(?=")/, 'utf-8').gsub(/&#x[0-1]?[0-9a-fA-F];/, ' ').gsub(/[\0-\x1f\x7f\u2028]/, ' ')
        XML::Reader.string(reader, options: XML::Parser::Options::NOERROR, encoding: XML::Encoding::UTF_8)
      end
    end

    def analyze_line(line)
      @doc[:term_entry] = true if !line.scan(/termEntry/).nil? && !line.scan(/termEntry/).empty?
      if line.scan(/(?<=lang=\S)\S+(?=')/).nil? || line.scan(/(?<=lang=\S)\S+(?=')/).empty?
        language = line.scan(/(?<=lang=\S)\S+(?=")/).uniq
      else
        language = line.scan(/(?<=lang=\S)\S+(?=')/).uniq
      end
      @doc[:source_language] = language[0] if line.include?('lang=') && !language.empty? && @doc[:source_language].empty? && @doc[:term_entry]
      @doc[:tc][:counter] += line.scan(/<\/termEntry>/).count
      @doc[:term][:counter] += line.scan(/<\/term>/).count
      if !@doc[:source_language].empty?
        language.each_with_index do |lang, index|
          next if @doc[:source_language].eql?(lang)
          @doc[:language_pairs] << [@doc[:source_language], lang]
        end
        @doc[:language_pairs] = @doc[:language_pairs].uniq
      end
    end

    def parse_file(reader)
      tag_stack = []
      while reader.read do
        if reader.node_type.to_i.eql?(1) && reader.read_string.nil?
          tag_stack.pop
        else
          if !tag_stack.include?(reader.name)
            tag_stack.push(reader.name)
            eval_state(tag_stack, reader)
          elsif tag_stack.last == reader.name
            tag_stack.pop
          end
        end
      end
      @doc[:tc][:vals].pop if @doc[:tc][:vals].last[0] != @doc[:term][:vals].last[0]
      reader.close
    end

    def eval_state(tag_stack,reader)
      case tag_stack.last.bytes.to_a
      when [109, 97, 114, 116, 105, 102] #martif
        @doc[:lang] = reader.get_attribute("lang") || reader.get_attribute("xml:lang")
        @doc[:language_pairs] << @doc[:lang]
      when [116, 101, 114, 109, 69, 110, 116, 114, 121] #termEntry
        generate_unique_id
        write_tc
      when [108, 97, 110, 103, 83, 101, 116] #langSet
        @doc[:term][:lang] = reader.get_attribute("lang") || reader.get_attribute("xml:lang")
        @doc[:language_pairs] << @doc[:term][:lang]
      when [116, 101, 114, 109] #term
        write_term(reader)
      when [116, 101, 114, 109, 78, 111, 116, 101] #termNote
        unless reader.read_string.nil?
          if reader.get_attribute("type").eql?("partOfSpeech")
            @doc[:term][:part_of_speech] = PrettyStrings::Cleaner.new(reader.read_string.downcase).pretty.gsub("\\","&#92;").gsub("'",%q(\\\'))
            @doc[:term][:vals].pop
            write_term_pos
          end
        end
      when [100, 101, 115, 99, 114, 105, 112] #descrip
        @doc[:tc][:definition] = PrettyStrings::Cleaner.new(reader.read_string).pretty.gsub("\\","&#92;").gsub("'",%q(\\\')) if reader.get_attribute("type").eql?("definition")
        @doc[:tc][:vals].pop
        write_tc
      end
    end

    def write_tc
      @doc[:tc][:vals] << [@doc[:tc][:id], @doc[:tc][:definition]]
      @doc[:tc][:definition] = ""
    end

    def write_term(reader)
      return if reader.read_string.nil?
      @doc[:term][:term] = PrettyStrings::Cleaner.new(reader.read_string).pretty.gsub("\\","&#92;").gsub("'",%q(\\\'))
      word_count = @doc[:term][:term].gsub("\s+", ' ').split(' ').length
      @doc[:term][:vals] << [@doc[:tc][:id], @doc[:term][:lang], @doc[:term][:part_of_speech], @doc[:term][:term]]
    end

    def write_term_pos
      @doc[:term][:vals] << [@doc[:tc][:id], @doc[:term][:lang], @doc[:term][:part_of_speech], @doc[:term][:term]]
    end

    def generate_unique_id
      @doc[:tc][:id] = [(1..4).map{rand(10)}.join(''), Time.now.to_i, @doc[:tc][:counter] += 1 ].join("-")
    end
  end
end

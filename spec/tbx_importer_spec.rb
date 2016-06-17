require 'spec_helper'

describe TbxImporter do
  it 'has a version number' do
    expect(TbxImporter::VERSION).not_to be nil
  end

  describe '#stats' do
    it 'reports the stats of a UTF-8 TBX file' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path)
      expect(tbx.stats).to eq({:tc_count=>25, :term_count=>51, :language_pairs=>[["en-US", "fr-fr"]]})
    end

    it 'reports the stats of a UTF-16 TBX file' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-16).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path)
      expect(tbx.stats).to eq({:tc_count=>10, :term_count=>21, :language_pairs=>[["EN-US", "PL"], ['EN-US', 'FR']]})
    end

    it 'reports the stats of a UTF-16 TBX file' do
      file_path = File.expand_path('/Users/diasks2/Desktop/grz_viva.tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path)
      expect(tbx.stats).to eq({:tc_count=>708, :term_count=>1502, :language_pairs=>[["EN", "DE"]]})
    end
  end

  describe '#import' do
    it 'imports a UTF-8 TBX file' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0].length).to eq(25)
    end

    it 'imports a UTF-8 TBX file 2' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[1].length).to eq(51)
    end

    it 'imports a UTF-8 TBX file 3' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0][-1][0]).to eq(tbx[1][-1][0])
    end

    it 'imports a UTF-8 TBX file 4' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0][1][1]).to eq("To shorten the fractional part of a number, increasing the last remaining (rightmost) digit or not, according to whether the deleted portion was over or under five.")
    end

    it 'imports a UTF-8 TBX file 5' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[1][1][2]).to eq("verb")
    end

    it 'imports a UTF-8 TBX file 6' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-8).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0][4][1]).to eq("The mode of a command-line application where it does not display confirmation messages or any other user interface items that normally appear on screen. The switch for quiet mode is typically q.")
    end

    it 'imports a UTF-16 TBX file' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-16).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0].length).to eq(10)
    end

    it 'imports a UTF-16 TBX file 2' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-16).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[1].length).to eq(21)
    end

    it 'imports a UTF-16 TBX file 3' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-16).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0][-1][0]).to eq(tbx[1][-1][0])
    end

    it 'imports a UTF-16 TBX file 4' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-16).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[0][1][1]).to eq('')
    end

    it 'imports a UTF-16 TBX file 5' do
      file_path = File.expand_path('../tbx_importer/spec/sample_files/sample_1(utf-16).tbx')
      tbx = TbxImporter::Tbx.new(file_path: file_path).import
      expect(tbx[1][1][2]).to eq('')
    end
  end
end

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

  end
end

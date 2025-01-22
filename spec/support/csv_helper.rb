module CsvHelper
  def load_seb_fixture
    fixture_path = Rails.root.join('spec/fixtures/files/test_seb.csv')
    # Force UTF-8 encoding and handle BOM
    file_content = File.read(fixture_path).force_encoding('UTF-8').gsub("\xEF\xBB\xBF", '')

    tempfile = Tempfile.new(%w[test_seb .csv])
    tempfile.write(file_content)
    tempfile.rewind

    Rack::Test::UploadedFile.new(
      tempfile.path,
      'text/csv',
      true
    )
  end
end
module CsvHelper
  def load_seb_fixture
    fixture_path = Rails.root.join('spec/fixtures/files/test_seb.csv')
    Rack::Test::UploadedFile.new(
      fixture_path,
      'text/csv',
      true
    )
  end

  def load_swed_fixture
    fixture_path = Rails.root.join('spec/fixtures/files/test_swed.csv')
    Rack::Test::UploadedFile.new(
      fixture_path,
      'text/csv',
      true
    )
  end

  def load_invalid_fixture
    fixture_path = Rails.root.join('spec/fixtures/files/test_invalid.csv')
    Rack::Test::UploadedFile.new(
      fixture_path,
      'text/csv',
      true
    )
  end
end

require "spec_helper"

RSpec.describe "OMIT RECORD IF Clause" do
  let(:sql) do
    format_sql <<-SQL
    SELECT
      repository.url
    FROM
      publicdata:samples.github_nested
    OMIT RECORD IF
      (COUNT(payload.pages.page_name) <= 80)
    SQL
  end

  subject do
    BB.select("repository.url").
      from("publicdata:samples.github_nested").
      omit_record_if("COUNT(payload.pages.page_name) <= ?", 80).
      to_sql
  end

  it { is_expected.to eq sql }
end

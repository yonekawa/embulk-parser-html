require 'spec_helper'

describe Embulk::Parser::Html do
  describe '#parse' do
    before :each do
      task_mock = double('task_mock')
      schema_mock = double('schema_mock')
      page_builder_mock = double('page_builder_mock')
      allow(task_mock).to receive(:[]).with('schema').and_return({
        'name' => { 'xpath' => '//table[@class="table1"]/tr/td[1]', 'type' => 'string' },
        'amount' => { 'xpath' => '//table[@class="table1"]/tr/td[2]', 'type' => 'long' },
        'description' => { 'xpath' => '//table[@class="table1"]/tr/td[3]', 'type' => 'string' }
      })

      @parser = Embulk::Parser::Html.new(task_mock, schema_mock, page_builder_mock)
    end

    context 'with valid html' do
      let(:html) { support_file('html/valid.html').read }

      it 'should parse by xpath' do
        result = @parser.send(:parse, html)
        expect(result.length).to eql(2)
        expect(result[0][0]).to eql('Book')
        expect(result[0][1]).to eql(1000)
        expect(result[0][2]).to eql('great book')

        expect(result[1][0]).to eql('Food')
        expect(result[1][1]).to eql(3000)
        expect(result[1][2]).to eql('delicious food')
      end
    end
  end
end

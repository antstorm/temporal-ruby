require 'temporal/connection/serializer/query_failure'
require 'temporal/workflow/query_result'

describe Temporal::Connection::Serializer::QueryFailure do
  let(:converter) do
    Temporal::ConverterWrapper.new(
      Temporal::Configuration::DEFAULT_CONVERTER,
      Temporal::Configuration::DEFAULT_PAYLOAD_CODEC
    )
  end

  describe 'to_proto' do
    let(:exception) { StandardError.new('Test query failure') }
    let(:query_result) { Temporal::Workflow::QueryResult.failure(exception) }

    it 'produces a protobuf' do
      result = described_class.new(query_result, converter).to_proto

      expect(result).to be_a(Temporalio::Api::Query::V1::WorkflowQueryResult)
      expect(result.result_type).to eq(Temporalio::Api::Enums::V1::QueryResultType.lookup(
        Temporalio::Api::Enums::V1::QueryResultType::QUERY_RESULT_TYPE_FAILED)
      )
      expect(result.error_message).to eq('Test query failure')
    end
  end
end

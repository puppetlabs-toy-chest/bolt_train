# frozen_string_literal: true

require 'spec_helper'
require 'bolt_spec/run'
require 'json'

describe 'bolt_train integration' do
  include BoltSpec::Run
  let(:bolt_config) { { 'modulepath' => "#{RSpec.configuration.module_path}:#{File.join(Dir.pwd, 'spec/fixtures')}" } }
  let(:bolt_inventory) do
    {
      'version' => 2,
      'targets' => [
        {
          'name' => 'bolt-train',
          'config' => {
            'transport' => 'remote',
            'remote' => {
              'train_api_url' => 'https://localhost:5000'
            }
          }
        }
      ]
    }
  end
  let(:output_dir) { '/tmp/bolt-train-queue' }

  it 'runs a plan that hits all endpoints and creates a valid run file' do
    plan_result = run_plan('test', {})
    expect(plan_result).to include('status' => 'success')
    last_modified = Dir.glob("#{output_dir}/*").max_by { |f| File.mtime(f) }
    result = JSON.parse(File.read(last_modified))
    expect(result).to include('session')
    expect(result['session']).to include('commands')
  end
end

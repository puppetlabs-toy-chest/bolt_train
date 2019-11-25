#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../ruby_task_helper/files/task_helper.rb'
require_relative '../lib/request_helper.rb'
require 'json'
require 'open3'

class BoltTrainSession < TaskHelper
  def session(opts)
    begin
      uri = "#{opts[:_target][:train_api_url]}/session/create"
      body = { email: opts[:email] }
      resp = RequestHelper.request(uri, body)
    rescue StandardError => e
      # TODO: meaningful error handing
      raise TaskHelper::Error.new(e.message, 'bolt-train/error')
    end
    JSON.parse(resp.body)
  end

  def task(opts)
    session(opts)
  end
end

BoltTrainSession.run if $PROGRAM_NAME == __FILE__

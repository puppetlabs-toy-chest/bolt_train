#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../ruby_task_helper/files/task_helper.rb'
require_relative '../lib/request_helper.rb'
require 'json'
require 'open3'

class BoltTrainMove < TaskHelper
  def session(opts)
    begin
      uri = "#{opts[:_target][:train_api_url]}/command/move"
      body = { direction: opts[:direction], speed: opts[:speed], time: opts[:time] }
      resp = RequestHelper.request(uri, body, opts[:token])
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

BoltTrainMove.run if $PROGRAM_NAME == __FILE__

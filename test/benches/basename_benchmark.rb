require 'test_helper'
require 'benchmark/ips'

BPATH = '/home/gumby/work/ruby.rb'

RURU_EXAMPLE = RuruExample.allocate

Benchmark.ips do |x|
  x.report('Ruby\'s C impl') do
    File.basename(BPATH)
    File.basename(BPATH, '.rb')
  end

  x.report('with pure input') do
    FfiExample.basename_with_pure_input(BPATH)
    FfiExample.basename_with_pure_input(BPATH, '.rb')
  end

  x.report('ruby nil guard') do
    FfiExample.basename_nil_guard(BPATH)
    FfiExample.basename_nil_guard(BPATH, '.rb')
  end

  x.report('rust nil guard') do
    FfiExample.basename_with_nil(BPATH)
    FfiExample.basename_with_nil(BPATH, '.rb')
  end

  x.report('with type safety') do
    FfiExample.file_basename(BPATH)
    FfiExample.file_basename(BPATH, '.rb')
  end

  x.report('through ruru') do
    RURU_EXAMPLE.basename(BPATH, '')
    RURU_EXAMPLE.basename(BPATH, '.rb')
  end

  x.compare!
end

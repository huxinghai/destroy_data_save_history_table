# -*- encoding: utf-8 -*-
require File.expand_path('../lib/destroy_data_save_history_table/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["kaka"]
  gem.email         = ["huxinghai1988@gmail.com"]
  gem.description   = %q{mongoid 删除的数据保存在历史表}
  gem.summary       = %q{mongoid 删除的数据保存在历史表}
  gem.homepage      = "https://github.com/huxinghai1988/destroy_data_save_history_table"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "destroy_data_save_history_table"
  gem.require_paths = ["lib"]
  gem.version       = DestroyDataSaveHistoryTable::VERSION
end

require 'date'
require 'yaml'

# 昔はYAML.load_file('mydata.yml')でも表示できたが、悪意のあるデータも無差別に扱えたため現在では許可しないとDate型を扱えない仕様に
# 同様にaliases: trueも設定する必要あり
# data = YAML.safe_load(File.read('mydata.yml'), permitted_classes: [Date], aliases: true)
# p data

# 分割したデータの表示
# File.open('mydata.yml') do |io|
#   YAML.load_stream(io) do |data|
#     p data
#   end
#  end

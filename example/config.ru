require '../lib/mcnamara'
require 'myapp'

use SOC::McNamara, "#{::File.dirname(__FILE__) + '/public/css'}"

run MyApp

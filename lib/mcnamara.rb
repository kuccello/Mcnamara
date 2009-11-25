=begin
  Copyright notice
  =============================================================================
  Copyright (c) 2009 Kristan 'Krispy' Uccello <krispy@soldierofcode.com> - Soldier Of Code

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  ==============================================================================

  ==============================================================================
  LICENSE
  ==============================================================================
  see LICENSE file for details

=end
require 'rubygems'
require 'spy_vs_spy'

module SoldierOfCode

  # MAC~nu~Mare-ah
  class McNamara

    def initialize(app, css_dir)
      @app = app
      @css_dir = css_dir
    end

    def call(env)

      begin
      # establish what browser we are dealing with
      # hey! is spy-vs-spy upstream?
      spy_vs_spy = env['soldierofcode.spy-vs-spy']
      unless spy_vs_spy
        http_user_agent = env['HTTP_USER_AGENT']
        env['soldierofcode.spy-vs-spy'] = SpyVsSpy.new(http_user_agent)
        spy_vs_spy = env['soldierofcode.spy-vs-spy']
      end

      # look for what css we are after
      request_path = env['REQUEST_PATH']
      if request_path =~ /\.css$/

        # need a base directory to scann...
        # TODO -- ripe for a cache
        possible_overrides = []
        possible_overrides << "-#{spy_vs_spy.browser}-#{spy_vs_spy.version.major}-#{spy_vs_spy.version.minor}-#{spy_vs_spy.version.sub}.css" if spy_vs_spy.version.major && spy_vs_spy.version.minor && spy_vs_spy.version.sub
        possible_overrides << "-#{spy_vs_spy.browser}-#{spy_vs_spy.version.major}-#{spy_vs_spy.version.minor}.css" if spy_vs_spy.version.major && spy_vs_spy.version.minor
        possible_overrides << "-#{spy_vs_spy.browser}-#{spy_vs_spy.version.major}.css" if spy_vs_spy.version.major
        
        possible_overrides << "-#{spy_vs_spy.browser}.css"

        Dir["#{@css_dir}/**/*.css"].each do |css_file|
          possible_overrides.each do |override|
            request_path_sub = request_path[1..-1].downcase.sub(/\.css/, override)

            file_of_intrest = request_path_sub.split("/").last
#            puts "#{__FILE__}:#{__LINE__} #{__method__} #{file_of_intrest.downcase} |||| #{css_file.downcase[1..-1]}"

            if css_file[1..-1].downcase =~ Regexp.new("#{file_of_intrest.downcase}$")
#              puts "#{__FILE__}:#{__LINE__} #{__method__} I'm IN!!"
              # this is the file we want to serve
              css = 'Oh oo - I droped the bomb'
              File.open(css_file, "r") {|f| css = f.read}
              return [200,{"Content-Type"=>"text/css"},css]
            end
          end
        end
      else
        @app.call(env)
      end
      rescue => e
        puts "#{__FILE__}:#{__LINE__} #{__method__} #{e} - #{e.backtrace}"
      end

    end
  end
end
SOC = SoldierOfCode unless SOC

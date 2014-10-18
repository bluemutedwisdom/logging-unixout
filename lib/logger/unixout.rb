#!ruby

# Copyright 2014 Evernote Corp. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'logger'

class Logger::Unixout < Logger

    def string_severity(sev)
        case sev
        when Logger::Unixout::DEBUG
            'debug'
        when Logger::Unixout::INFO
            'info'
        when Logger::Unixout::WARN
            'warn'
        when Logger::Unixout::ERROR
            'error'
        when Logger::Unixout::FATAL
            'fatal'
        else
            'unknown'
        end
    end

    def text_of(message)
        if message.is_a? String
            message
        elsif
            message.is_a? StandardError
            "#{message} (#{message.class}): message.backtrace.join(' -> ')"
        else
            message.inspect
        end
    end

    def initialize(outfh=STDOUT, errfh=STDERR)
        super outfh
        @outfh = outfh
        @errfh = errfh

        self.formatter = lambda do |sev, timestamp, program, message|
            if sev = Logger::Unixout::DEBUG
                line = "DBG(#{program}): #{text_of message}"
            else
                line = "#{program} #{string_severity(sev)}: #{text_of message}"
            end
        end
    end

    def add(severity, message=nil, progname=nil)
        progname ||= self.progname
        message ||= yield
        (severity >= Logger::Unixout::WARN ? @errfh : @outfh) <<
            self.formatter.call(severity, Time.now.strftime(self.datetime_format),
                                progname, message)
    end

end

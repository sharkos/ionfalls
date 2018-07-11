=begin
-------------------------------------------------------------------------------
 _             _______     _ _
| |           (_______)   | | |
| | ___  ____  _____ _____| | |  ___
| |/ _ \|  _ \|  ___|____ | | | /___)
| | |_| | | | | |   / ___ | | ||___ |
|_|\___/|_| |_|_|   \_____|\_)_|___/

(C)opyright 2011, LeafScale Systems, Inc. and P. Chris Tusa
All Rights Reserved

*! Unauthorized copying of this file, via any medium is strictly prohibited !*

You may NOT copy, modify, distribute, reverse-engineer, decompile, take photos
or screen-shots, print, print to any file format, or in any way reproduce this
software or its source code without the express and written permission of the
Author(s) and LeafScale Systems, Inc.  You may NOT read, view, or discuss the
code, contents, algorithms, documentation, debugs and traces, configuration, or
any other output generated without a signed and certified mutual Non-Disclosure
Agreement between the Author(s)/LeafScale Systems, Inc. and specified parties.

These statements may be enforced under penalty of law. Failure to comply with
these restrictions will result in criminal prosecution to the full extent of
Local, State, Federal, and International laws where applicable.
-------------------------------------------------------------------------------
=end
=begin rdoc
= IonIO::Output
Output provides routines to handle displaying to console.
=end

module IonIO
  module Output

    # This class provides class methods for paging and an object which can conditionally page given a terminal size that is exceeded.
    # adapted from Hirb gem: credit to Gabriel Horner
    class Pager
      class<<self

        # Pages with a ruby-only pager which either pages, displays remaining or quits.
        def default_pager(output, options={})
          pager = new(options[:width], options[:height])
          while pager.activated_by?(output)
            puts pager.slice!(output)
            pt = IonTemplate::Template.new('pager_default.ftl').stringify.chomp
            print pt
            prompt = IonIO::Input.pagerkey_default
            if prompt.upcase == 'N' # Stop Paging
              return
            elsif prompt.upcase == 'Y' # Next Page
              print " \b\b \b" * (pt.length + 1)
            elsif prompt.upcase == 'C' # Continue
              print " \b\b \b" * (pt.length + 1)
              break
            end
            #return unless continue_paging?
          end          
          print output
        end

        private
        def basic_pager(output)
          pager = IO.popen(pager_command, "w")
          begin
            save_stdout = STDOUT.clone
            STDOUT.reopen(pager)
            STDOUT.puts output
          rescue Errno::EPIPE
          ensure
            STDOUT.reopen(save_stdout)
            save_stdout.close
            pager.close
          end
        end

#        def continue_paging?
#          print "=== Press enter/return to continue or q to quit: ==="
#          !$stdin.gets.chomp[/q/i]
#        end
        #:startdoc:
      end

      attr_reader :width, :height

      # Create a new instance of Pager with defaults
      def initialize(width=80, height=24)
        resize(width, height)
      end

      # Pages given string using configured pager.
      def page(string)
        self.class.default_pager(string, :width=>@width, :height=>@height)
        string.replace("") # Blank String to clear for next run
      end

      def slice!(output) #:nodoc:
        effective_height = @height - 1 # takes into account pager prompt
        # could use output.scan(/[^\n]*\n?/) instead of split
        sliced_output = output.split("\n").slice(0, effective_height).join("\n")
        output.replace output.split("\n").slice(effective_height..-1).join("\n")
        sliced_output
      end

      # Determines if string should be paged based on configured width and height.
      def activated_by?(string_to_page)
        string_to_page.count("\n") > @height
      end

      # Set the size of the end-users's terminal by probing via IonTerm
      def resize(width, height) #:nodoc:
        @width =  IonTerm::ConsoleReader.new.getTermwidth
        @height = IonTerm::ConsoleReader.new.getTermheight
      end
    end #/class

  end #/module Output
end #/module IonIO


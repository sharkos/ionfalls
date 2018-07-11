=begin
-------------------------------------------------------------------------------
 _             _______     _ _
| |           (_______)   | | |
| | ___  ____  _____ _____| | |  ___
| |/ _ \|  _ \|  ___|____ | | | /___)
| | |_| | | | | |   / ___ | | ||___ |
|_|\___/|_| |_|_|   \_____|\_)_|___/

(C)opyright 2012, LeafScale Systems, Inc. and P. Chris Tusa
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
= IonTemplate (Template Parser)
IonTemplate uses FreeMarker templates to provide screen & web output.
A JRuby wrapper for the FreeMarker template engine JAR file.
=end

module IonTemplate

begin
  require 'class/freemarker-2.3.20.jar'
rescue LoadError
  raise "ERROR: unable to load embedded template engine."
end

# Import of Java Class for FreeMarker Template Engine
module Fm
   include_package "freemarker.template"
end

# Workaround if CFG has not been loaded or parsed.
if $cfg == nil then
  $cfg = {"global" => {'theme' => TPL_DEFAULT }}  
end
  
unless File.exist?(TPL_DIR+'/'+$cfg['global']['theme'])
  puts "[ERROR] Could not located user defined theme. Falling back to default."
  themedir = TPL_DEFAULT
else
  themedir = $cfg['global']['theme']
end



$tcfg = Fm::Configuration.new()
  $tcfg.setDirectoryForTemplateLoading(JavaIO::File.new("./tpls/#{themedir}"))
  $tcfg.setObjectWrapper(Fm::DefaultObjectWrapper.new)


# The template class. Used to create an instance of template from an action
class Template
   # Sets values when calling new method for a template
   def initialize(filename)
      @tout = JavaIO::OutputStreamWriter.new(JavaLang::System.out)
      @template = $tcfg.getTemplate(filename)
      @tcolors = JavaUtil::HashMap.new
      @tdata = JavaUtil::HashMap.new

      # Push ansicolors into Global Template vars as color.
      ANSICOLORS.each do |key, value|
            @tcolors.put(key, value)
      end
   end

   # Renders the template to stdout
   def render(data={})
      if data.class == Hash
         data.each do |key, value|
            @tdata.put(key, value)
         end
         @tdata.put("color", @tcolors)
         @template.process(@tdata, @tout)
         @tout.flush
      else
         puts "IonTemplate: Parsing error - data not of type Ruby::Hash. Type was (#{data.class})"
      end
   end #/def


   # Renders the template to a string so it may be paged using the Pager facility
   def stringify(data={})
      if data.class == Hash
         data.each do |key, value|
            @tdata.put(key, value)
         end
         @tdata.put("color", @tcolors)
         @sout = JavaIO::StringWriter.new()

         @template.process(@tdata, @sout)
         return @sout.toString
      else
         puts "IonTemplate: Parsing error - data not of type Ruby::Hash. Type was (#{data.class})"
      end
   end #/def

    # TODO: Migrate this to Active Record if required
    # Parses an array of hashes created by a Sequel Dataset, and constructs a new
    # array of JavaUtil::HashMap(s) with the keys converted from symbols to string.
   def Template.parse_dataset(sqlset)
     if sqlset.class == Array
       newarray = []
       sqlset.each do |h|
         if h.class == Hash
           newhash = JavaUtil::HashMap.new
           h.each_pair do |k ,v|
             newhash.put(k.to_s, v)
           end
         end
         newarray.push(newhash)
       end
     end
     return newarray
   end

    def Template.parse_hash(sqlset)
     if sqlset.class == Hash
           newhash = JavaUtil::HashMap.new
           sqlset.each_pair do |k ,v|
             newhash.put(k.to_s, v)
           end
     end
     return newhash
   end

end #/class

  # Display a template file. If a hash is passed in, then variables
  # will be substituted by FreeMarker.
  def IonTemplate::display(template, hashdata=nil)
    t = IonTemplate::Template.new(template)
    p = IonIO::Output::Pager.new
    if hashdata == nil
      if $session.nil? == false && $session.pref_term_pager == true
        p.page(t.stringify())
      else
        t.render()
      end
    else
      if $session.nil? == false && $session.pref_term_pager == true
        p.page(t.stringify(hashdata))
      else
        t.render(hashdata)
      end
    end
    # Ensure ANSI colors are reset after template display.
    print ANSI_RESET
  end

=begin ## OLD DISPLAY BEFORE INTEGRATING PAGER ##
  # Display a template file. If a hash is passed in, then variables
  # will be substituted by FreeMarker.
  def IonTemplate::display(template, hashdata=nil)
    t = IonTemplate::Template.new(template)
    if hashdata == nil
      t.render()
    else
      t.render(hashdata)
    end
    # Ensure ANSI colors are reset after template display.
    print ANSI_RESET
  end
=end


end #/module

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
= rubyclassextensions
Extensions to Ruby including Java Mixins for JRuby
=end

# Java Class Mix-Ins
require 'java'

# Imports java.lang as Ruby::JavaLang
module JavaLang
    include_package "java.lang"
end

# Imports java.io as Ruby::JavaIO
module JavaIO
    include_package "java.io"
end

# Imports java.util as Ruby::JavaUtil
module JavaUtil
    include_package "java.util"
end

# Imports IonTerm Jar for ANSI Console Functions (forked from JLine-1.1)
require 'class/ionterm-1.1-SNAPSHOT.jar'
module IonTerm
  include_package "ionterm"
end

# Import ApacheCommons-Lang Library
require 'class/commons-lang3-3.1.jar'
module ApacheCommonsLang
  include_package "org.apache.commons.lang3"
end

# Import ApacheCommons-Validator
require 'class/commons-validator-1.4.0.jar'
module ApacheCommonsValidator
  include_package "org.apache.commons.validator"    
end

# Imports the JaSypt encryption library
require 'class/jasypt-1.9.0.jar'
module JasyptPBE
  include_package "org.jasypt.encryption.pbe"
end

module JasyptSalt
  include_package "org.jasypt.salt"
end

module JasyptText
  include_package "org.jasypt.util.text"
end

# Extends fixunum class for some date/time shortcuts.
class Fixnum
  # Default fixnum class is in seconds (self).
  def seconds
    self
  end

  # Convert number of minutes to seconds (self).
  def minutes
    self * 60
  end

  # Convert number of hours to seconds (self).
  def hours
    self * 60 * 60
  end
  # Alias for hours when using a single hour grammar
  def hour
    self * 60 * 60
  end


  # Convert number of days to seconds (self)
  def days
    self * 60 * 60 * 24
  end
  # Convert Seconds to Minutes
  def sec_to_min
    self / 60
  end
end #/class Fixnum


# Extend the String Class with validation methods
class String
  # Return true if string contains only Alpha characters
  def is_alpha?
    ApacheCommonsLang::StringUtils.isAlpha(self)
  end

  # Returns true if string constains only Numeric characters
  def is_numeric?
    ApacheCommonsLang::StringUtils.isNumeric(self)
  end

  # Returns true if string is AlphaNumeric
  def is_alphanumeric?
    ApacheCommonsLang::StringUtils.isAlphanumeric(self)
  end

  # Return true if string contains only Alpha characters
  def is_spaced_alpha?
    ApacheCommonsLang::StringUtils.isAlphaSpace(self)
  end

  # Returns true if string constains only Numeric characters
  def is_spaced_numeric?
    ApacheCommonsLang::StringUtils.isNumericSpace(self)
  end

  # Returns true if string is AlphaNumeric
  def is_spaced_alphanumeric?
    ApacheCommonsLang::StringUtils.isAlphanumericSpace(self)
  end

  # Returns true if string is Blank. Similar to empty,
  # but looks for whitespace entries. 
  def is_blank?
    ApacheCommonsLang::StringUtils.isBlank(self)
  end

  # Returns true if string is NOT Blank.
  def is_notblank?
    ApacheCommonsLang::StringUtils.isNotBlank(self)
  end

  # Returns true if string meets email address criteria
  # Pure Ruby way, replaced with Apache Commons Validator
  #def is_email?
  #  if /^([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/.match(self)
  #    return true
  #  else
  #    return false
  #  end
  #end
  def is_email?    
    ApacheCommonsValidator::GenericValidator.isEmail(self)
  end

  # Returns true if string is a valid url
  def is_url?
    ApacheCommonsValidator::GenericValidator.isUrl(self)
  end

  # Returns true if string meets minimum length
  def minlength?(size)
    ApacheCommonsValidator::GenericValidator.minLength(self,size)
  end

  # Returns true if string meets maximum length
  def maxlength?(size)
    ApacheCommonsValidator::GenericValidator.maxLength(self,size)
  end

  # Returns true if string size is within bounds.
  def inbounds(min, max)
     ApacheCommonsValidator::GenericValidator.isInRange(self.length, min, max)
  end

end #/class String

# Extends TrueClass for Boolean Functions
class TrueClass
  # Flip the bit on a Boolean - True becomes False
  def toggle
    if self == true
      return false
    else
      return true
    end
  end
end

# Extends FalseClass for Boolean Functions
class FalseClass
  # Flip the bit on a Boolean - False becomes True
  def toggle
    if self == false
      return true
    else
      return false
    end
  end
end

# Disabling FFI support - breaks on NetBSD's OpenJDK
=begin
# Load FFI Support
require 'ffi'

# LIBC exec call.
module JExec
    extend FFI::Library
    ffi_lib("c")
    attach_function :execvp, [:string, :pointer], :int
    attach_function :fork, [], :int
end
=end
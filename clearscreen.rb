require 'class/ionterm.jar'
 module IonTerm
 include_package "ionterm" 
 end

IonTerm::ConsoleReader.new.clearScreen

#Java::jline.console.ConsoleReader.new.clearScreen

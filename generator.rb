require 'time'
require 'slop'


#############################################################
#                  F O R M A T E R s
#############################################################
class Formater
	class << self
		def get(str)
			case str.downcase
				when "html" then htmlFormater.new()
				when "svg" then htmlFormater.new()
			end
		end
	end
end


class SVGFormater < Formater
	def init(fout)
		@fout="#{fout}.svg"
		@tpl= DATA.read.split(/%%%.*$/)[2]
	    @out=[]
		@x,@y=0,0
		@dy=10
	end
	def template()
		@tpl
	end
	def caption(level,text)
	   @out << ""
	end
	def comment(comment)
	end
	def evaluated(line,ev)
	end
	def end_doc()
	end
	def generate()
      if @out.size==0
		puts "no output !"
		return
	  end
	  File.write(@fout,"")
	  system("start",@fout)
	end
end

class HtmlFormater < Formater
	def init(fout)
		@fout="#{fout}.html"
	    @out=[]
		@tpl= DATA.read.split(/%%%.*$/)[1]
	end
	def pre(str)
	  str.gsub("&","&amp;").gsub("<","&lt;").gsub(">","&gt;")
	end
	def template()
		@tpl
	end
	def caption(level,text)
		@out << "<h#{level}>#{pre(text)}</h#{level}>"
	end
	def comment(comment)
		@out << "<p><b>#{pre(comment)}</b></p>"
	end
	def evaluated(line,ev)
		lb= ev.size>30 ? "<br>&nbsp;&nbsp;&nbsp;" : ""
	    @out << "<code class='c'>#{pre(line)} </code>=>#{lb} <code class='r'>#{pre(ev)}</code><br/>"
	end
	def end_doc()
	end
	def generate()
      if @out.size==0
		puts "no output !"
		return
	  end
	  t=template().
				gsub("%TITLE%",@name.gsub(/[\W_]/," ")).
				gsub("%CONTENT%",@out.join("\n")).
				gsub("%DATE%",Time.now.to_datetime.rfc3339().gsub("T"," ")).
				gsub("%CSS%", @css!="" ? "<style>\n#{File.read(@css)}\n</style>" : "")
	  File.write(@fout,t)
	  system("start",@fout)
	end
end

#############################################################
# make a binding, independant of main object
class B
	def self.binding
	  loop { $binding= binding  ; break }
	end
end
B.binding()

class T
	def initialize(formater,filename,css)
	  @render=formater
	  @name=File.basename(filename.split(/\./,2).first)
	  @css=css
	  @render.init("tmp/#{@name}")
	end
	def caption(line)
		header,caption=line.split(/\s/,2)
		level=header.size+1
		@render.caption(level,caption.strip)
	end
	def comment(line)
		bidon,comment=line.split(/\s/,2)
		@render.comment(comment.strip)
	end
	def process(col)
	end
	def process(page)
	end
	def evaluate(line)
	    ev=eval(line,$binding).inspect
		@render.evaluated(line,ev)
	rescue Exception => e
		puts "ERROR for #{line} : #{e}"
		@render.evaluated(line,"ERROR : #{e}")
	end
	def end_doc()
	    @render.end_doc()
		@render.generate()
	end
end

#############################################################"""
##                M A I N 
#############################################################"""

opt=Slop.parse do |o|
  o.on "-v", "--version" do
    puts "#{$0} v0.1"
	exit(0)
  end
  o.on '--help' do
    puts o
    exit
  end
  o.string  "-f", "--format","output format : html or svg", default: "html"
  o.string  "-s", "--css","css file for render your sheat cheet", default: ""
end
filename=opt.args.last
css=opt[:css]
format=opt[:format]

if !filename
  puts opt
  exit(0)
end
unless File.readable?(filename)
  puts "File #{filename} do not exists !"
  exit(1)
end

unless css=="" || File.readable?(css)
  puts "File #{filename} do not exists !"
  exit(1)
end

puts "Process #{filename}..."

formater=Formater.get(format)
traitment=T.new(formater,filename,css)

File.read(filename).lines.each do |line| line.strip!
 next if line.size<1
 case line
 when /^#/ then     traitment.caption(line)
 when /^>/ then     traitment.comment(line)
 when /%col/ then   traitment.process(:col)
 when /%page/ then  traitment.process(:page)
 else
    traitment.evaluate(line)
 end 
end
traitment.end_doc()

__END__
%%% html
<html>
<head>
<title>%TITLE%</title>
<style>
body { margin: 0px; padding: 0px; }
h1 {text-align: center;}
h1,h2,h3,h4,h5,h6 { background: #034 ; color: white; padding-left: 3px;}
code.c { background: #EEE}
code.r { background: #AEE}
code { padding-left: 10px }
</style>
%CSS%
</head>
<body>
<h1>%TITLE%</h1>
<div id='cols'>
%CONTENT%
</div>
<br>
<hr>
<center>Generated at %DATE%</center>
</body>
</html>
%%% svg
<svg size="0 0 100% 100%">
<g>
</g>
</svg>

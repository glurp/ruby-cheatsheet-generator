require 'time'

#############################################################"""
class T
    class << self
	   def deflvar(lvar)
			lvar.each {|varname| attr_accessor(varname.to_sym)}
	   end
	end
	def initialize(lvar,filename)
	  self.class.deflvar(lvar)
	  lvar.each {|vn| self.instance_eval("#{vn}=nil")}
	  @name=File.basename(filename.split(/\./,2).first)
	  puts (self.methods - Object.methods).sort
	  @fout="#{@name}.html"
	  @out=[]
	end
	def template()
		DATA.read
	end
	def caption(line)
		header,caption=line.split(/\s/,2)
		level=header.size+1
		@out << "<h#{level}>#{pre(caption.strip)}</h#{level}>"
	end
	def comment(line)
		bidon,comment=line.split(/\s/,2)
		@out << "<p><b>#{pre(comment.strip)}</b></p>"
	end
	def process(col)
	end
	def process(page)
	end
	def evaluate(line)
	    ev=eval(line).inspect
		lb= ev.size>30 ? "<br>&nbsp;&nbsp;&nbsp;" : ""
	    @out << "<code class='c'>#{pre(line)} </code>=>#{lb} <code class='r'>#{pre(ev)}</code><br/>"
		puts "Eval of  #{line} \t: #{ev}"  
	rescue Exception => e
		puts "ERROR for #{line} : #{e}"
	end
	def pre(str)
	  str.gsub("&","&amp;").gsub("<","&lt;").gsub(">","&gt;")
	end
	def generate()
	  t=template().gsub("%TTITLE%",@name).
				gsub("%CONTENT%",@out.join("\n")).
				gsub("%DATE%",Time.now.to_datetime.rfc3339())	
	  File.write(@fout,t)
	  system("start",@fout)
	end
end

#############################################################"""
##                M A I N 
#############################################################"""

filename= ARGV.size==1 ? ARGV.first : Dir.glob("*.snip.rb").to_a.first
unless File.readable?(filename)
  puts "File #{filename} do not exists !"
  exit(1)
end
puts "Process #{filename}..."
str=File.read(filename)

lvar=str.lines.each_with_object([]) do |line,lv| 
 line.strip!
 next if line =~ /^[>#%]/
 varname = line[/^([a-zA-Z]\w*?)\s*?=.+$/,1]
 next unless varname && varname.size>0
 puts "create variable '#{varname}' ..."
 lv << varname
end

traitment=T.new(lvar,filename)

str.lines.each do |line| line.strip!
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
traitment.generate()

__END__
<html>
<head>
<title>%TTITLE%</title>
<style>
body { margin: 0px; padding: 0px; }
h1,h2,h3,h4,h5,h6 { background: #034 ; color: white; padding-left: 3px;}
code.c { background: #EEE}
code.r { background: #AEE}
code { padding-left: 10px }
</style>
</head>
<body>
<h1>%TTITLE%</h1>
%CONTENT%
<br>
<hr>
<center>Generated at %DATE%</center>
</body>
</html>
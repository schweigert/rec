require 'socket'
require 'thread'
require 'timeout' 

class Broadcast

	def initialize port
		@port = port
		puts "Iniciand broadcast na porta #{@port}"
		@udp = UDPSocket.new
		@udp.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
		@thread0 = Thread.new {
			self.work
		}
	end

	def work
		loop {
			# Enviando Broadcast a cada 1 segundo
			@udp.send("1",0,"<broadcast>", @port)
			sleep 1
		}
	end

	def close
		@thread0.kill
		@udp.close
	end

end


class Core
	def initialize port
		@port = port
		@ipsout = []
		@listvar = []
		$tabvarout=[rand(256),rand(256),rand(256)]
		@tcp  = TCPServer.new @port
		@thread1 = Thread.new {
			self.work
		}
		
	end

	def work
		loop {
			begin
			Timeout.timeout 2 do
				@varout=$tabvarout
				if $ips.empty?
					puts "Aguardando TCP em #{@port}"
				end
				@client = @tcp.accept
				@ipclia = @client.peeraddr[3].chomp
				puts "Conexao recebida de #{@ipclia}"
				if not $ips.include? @client
					puts "#{@ipclia} reconhecido e adicionado a lista"
					$ips << [@client,@ipclia,@varout]
				end
			end
			@ipsout = $ips
			@ipsouta = @ipsout
			rescue
				if @ipsout.any?
					for n in @ipsout
						begin
							Timeout.timeout 6 do
								@listvarout=[]
								for y in @ipsouta
									@listvarout<<[y[1],y[3]]
								end
								n[0].puts "#{@listvarout}"
								# puts "#{@listvarout} sent to #{n[1]}"
								n[3] = n[0].gets
								# puts "#{n[3]} recieved from #{n[1]}"
								end
						rescue
							puts "Client #{n[1]} logoff"
							@ipsout.delete(n)
						end
					end
					$ips = @ipsout
				end
			end
		}
	end

	def getIps
		copia = []
		for i in $ips
			copia << i
		end
		@ipclic = []
		for x in copia
			begin 
				@ipclic << x[1]
			rescue
				puts "#{x.to_s} Desconectou na verificacao"
			end
		end
	return @ipclic
	end
	
	def getvarout
		copiavarout = []
		for q in $ips
			copiavarout << q
		end
		@gvarout = []
		for x in copiavarout
			begin 
				@gvarout << x[3]
			rescue
				puts "#{x.to_s} Desconectou na verificacao"
			end
		end
	return @gvarout
	end
	
	def trafeco
		copiatra = []
		for t in $ips
			copiatra << t
		end
		@gtra = []
		for x in copiatra
			begin 
				@gtra << x[1]
				@gtra << x[3]
			rescue
				puts "#{x.to_s} Desconectou na verificacao"
			end
		end
	return @gtra
	end

	def close
		@thread1.kill
	end
end

$ips = []
broadcast = Broadcast.new 3030
core = Core.new 50321

loop {
	a = gets.chomp
	if a == "close"
		broadcast.close
   		core.close
   		break
	end
	if a == "v"
		puts "Lista de variaveis:"
		puts core.getvarout
	end
	if a == "i"
		puts "Atualizando lista de IP's"
		puts core.getIps
	end
	if a == "t"
		puts "Trafeco de dados"
		puts core.trafeco
	end
}

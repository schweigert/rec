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
		@tcp  = TCPServer.new @port
		@thread1 = Thread.new {
			self.work
		}
		
	end

	def work
		loop {
			begin
			Timeout.timeout 2 do
				puts "Aguardando TCP em #{@port}"
				@client = @tcp.accept
				@ipclia = @client.peeraddr[3].chomp
				puts "Conexao recebida de #{@ip}"
				if not $ips.include? @client
					puts "#{@ipclia} reconhecido"
					$ips << @client
					puts "#{@ipclia} foi adicionado a lista"
				end
			end
			@ipsout = $ips
			rescue
				if @ipsout.any?
					for n in @ipsout
						@ipclib = n.peeraddr[3].chomp
						begin
							Timeout.timeout 1 do
								n.puts "r u there #{@ipclib} ?"
							end
						rescue
							puts "Client #{@ipclib} logoff"
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
				@ipclic << x.peeraddr[3].chomp
			rescue
				puts "#{x.to_s} Desconectou na verificacao"
			end
		end
	return @ipclic
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
   puts "Atualizando lista de IP's"
   puts core.getIps
}

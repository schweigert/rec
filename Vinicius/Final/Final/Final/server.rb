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
				puts "Aguardando TCP em #{@port}"
				@client = @tcp.accept
				@ipclia = @client.peeraddr[3].chomp
				puts "Conexao recebida de #{@ipclia}"
				if not $ips.include? @client
					puts "#{@ipclia} reconhecido e adicionado a lista"
					$ips << [@client,@ipclia,@varout]
				end
			end
			@ipsout = $ips
			rescue
				if @ipsout.any?
					for n in @ipsout
						begin
							Timeout.timeout 5 do
								n[0].puts "#{n[2]}"
								puts "#{n[2]} sent to #{n[1]}"
								n[3] = n[0].gets
								puts "#{n[3]} recieved from #{n[1]}"
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

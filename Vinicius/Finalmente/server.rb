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
		@tcp  = TCPServer.new @port
		@thread1 = Thread.new {
			self.work
		}
		
	end

	def work
		loop {
			begin
			Timeout.timeout 2 do
				if $ips.empty?
					puts "Aguardando TCP em #{@port}"
				end
				@client = @tcp.accept
				@ipclia = @client.peeraddr[3].chomp
				puts "Conexao recebida de #{@ipclia}"
				if not $ips.include? @client
					$ips << [@client,@ipclia]
					puts "#{@ipclia} reconhecido e adicionado a lista"
				end
			end
			@ipsout = $ips
			rescue
				if @ipsout.any?
					@listxixivar = []
					@listxixivalor = []
					@varalter = $listcocovar
					for n in @ipsout
						begin
							Timeout.timeout 6 do
								n[0].puts "Variaveis do servidor: #{@varalter}"
								@dadolist = n[0].gets
								@listdado = @dadolist.split (%r{,\s*})
								@listdado[3] = @listdado[3].delete("[")
								@listdado[3..5] = @listdado[3..5].map {|x| x.to_i}
								n[2] = @listdado
								@listxixivar << [n[1],n[2][0],n[2][1],n[2][2]]
								@listxixivalor << [n[1],n[2][3],n[2][4],n[2][5]]
							end
						rescue
							puts "Client #{n[1]} logoff"
							@ipsout.delete(n)
						end
					end
					$listcocovar = @listxixivar
					$listcocovalor = @listxixivalor
					$ips = @ipsout
				end
			end
		}
	end

	def getIps
		@copiaip = []
		for i in $ips
			@copiaip << i
		end
		@ipcopia = []
		for i in @copiaip
			begin 
				@ipcopia << i[1]
			rescue
				puts "#{i[1].to_s} Desconectou na verificacao"
			end
		end
		return @ipcopia
	end
	
	def getvar
		@copiavar = []
		for i in $listcocovar
			begin 
				@copiavar << i
			rescue
				puts "Desconectou na verificacao"
			end
		end
	return @copiavar
	end
	
	def trafego
		@copiavarba = []
		for i in $listcocovar
			@copiavarba << i
		end
		@copiavalorba = []
		for i in $listcocovalor
			@copiavalorba << i
		end
		@tracopiaa = []
		for i in @copiavarba
			for l in @copiavalorba
				begin 
					@tracopiaa << "Cliente #{i[0]} possui as variáveis \n#{i[1]} = #{l[1]} \n#{i[2]} = #{l[2]} \n#{i[3]} = #{l[3]}"
				rescue
					puts "Desconectou na verificacao"
				end
			end
		end
	return @tracopiaa.uniq
	end

	def close
		@thread1.kill
	end
end

$ips = []
broadcast = Broadcast.new 3030
broadcast = Broadcast.new 3035
broadcast = Broadcast.new 3040
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
		puts core.getvar
	end
	if a == "i"
		puts "Atualizando lista de IP's"
		puts core.getIps
	end
	if a == "t"
		puts "Trafego de dados"
		puts core.trafego
	end
}

require 'socket'
require 'timeout'

class Conexao
	def initialize
			@thread1=Thread.new {
				
				self.work
				
			}
	end
	
	def work
		loop{
		puts "Aguardando Broadcast na porta 3030"
		dado,$endereco = $udp.recvfrom(1)
		puts "Solicitacao recebida de #{$endereco[3]}"
		begin
			Timeout.timeout 3 do
				@tcp = TCPSocket.new $endereco[3], 50321
			end
			puts "Conexão realizada com sucesso com o servidor"
			puts "iniciando comunicacao via TCP"
			loop {
				@datin=@tcp.gets
				$datanin=@datin
				if not @datin.nil?
					# puts "#{@datin} recebido via TCP"
					@tabvarout=[rand(256),rand(256),rand(256)]
					$tabavarout=@tabvarout
					@tcp.puts "#{@tabvarout}"
					# puts "#{@tabvarout} enviado"
				else
					@tcp.close
					break
				end
			}
		rescue
			@tcp.close
			puts "Tentativa falha de conexão ao servidor"
			$udp.close
			$udp = UDPSocket.new
			$udp.bind('0.0.0.0',3030)
		end
	}
	end

	def trafecoin
		@copiain = "#{$datanin} recebido via TCP de #{$endereco[3]}"
		
		return @copiain
	end

	def trafecout
		@copiaout = "#{$tabavarout} enviados via TCP para #{$endereco[3]}"
		return @copiaout
	end

end


$endereco=[nil]
$udp = UDPSocket.new
$udp.bind('0.0.0.0',3030)
conexao = Conexao.new

loop {
	a = gets.chomp
	if a == "t"
		puts "dados recebidos"
		puts conexao.trafecoin
	end
	if a == "e"
		puts "dados enviados"
		puts conexao.trafecout
	end
}

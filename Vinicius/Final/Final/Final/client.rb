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
			Timeout.timeout 2 do
				@tcp = TCPSocket.new $endereco[3], 50321
			end
			loop {
				@varin=@tcp.gets
				if not @varin.nil?
					puts "#{@varin} recebido via TCP"
					@tabvarout=[rand(256),rand(256),rand(256)]
					@tcp.puts "#{@tabvarout}"
					puts "#{@tabvarout} enviado"
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
end


$endereco=[nil]
$udp = UDPSocket.new
$udp.bind('0.0.0.0',3030)
conexao = Conexao.new


loop {
	a = gets.chomp
   if a == "close"
   		break
   end
}

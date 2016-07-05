require 'socket'
require 'timeout'

class Conexao
	def initialize
			@thread1=Thread.new {
				$nomevarout="temperatura, pressao, umidade"
				$nomevaroutb=["temperatura","pressao","umidade"]
				self.work
				
			}
	end
	
	def work
		loop{
		puts "Aguardando Broadcast na porta 3035"
		dado,$endereco = $udp.recvfrom(1)
		puts "Solicitacao recebida de #{$endereco[3]}"
		begin
			Timeout.timeout 3 do
				@tcp = TCPSocket.new $endereco[3], 50321
			end
			puts "Conexão realizada com sucesso com o servidor"
			puts "iniciando comunicacao via TCP"
			loop {
				@datain = @tcp.gets
				$varserver = @datain
				if not @datain.nil?
					@varout = [rand(256),rand(256),rand(256)]
					$variout = @varout
					@tcp.puts "#{$nomevarout},#{$variout}"
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
			$udp.bind('0.0.0.0',3035)
		end
	}
	end


	def trafegoin
		@copiain = []
		@copiain << $varserver
		return @copiain
	end


	def trafegoout
		@copianome = []
		@copianome << $nomevaroutb
		@copiavar = []
		@copiavar << $variout
		@copiaout = []
		@copiaout << "#{@copianome[0][0]} = #{$variout[0]} \n#{@copianome[0][1]} = #{$variout[1]} \n#{@copianome[0][2]} = #{$variout[2]}"
		return @copiaout
	end

end


$endereco=[nil]
$udp = UDPSocket.new
$udp.bind('0.0.0.0',3035)
conexao = Conexao.new

loop {
	a = gets.chomp
	if a == "v"
		puts "Lista de variaveis disponiveis no servidor:"
		puts conexao.trafegoin
	end
	if a == "e"
		puts "Dados enviados"
		puts conexao.trafegoout
	end
}

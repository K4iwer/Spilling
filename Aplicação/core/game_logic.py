from PyQt6.QtCore import QObject, QTimer, pyqtSignal
import time

class GameLogic(QObject):
    next_level_signal = pyqtSignal(int, str, str)  # envia número e descrição da fase
    correct_answer_signal = pyqtSignal(str, str)   # envia mensagem de acerto
    wrong_answer_signal = pyqtSignal(str, str)   # envia mensagem de erro
    win_game_signal = pyqtSignal()

    def __init__(self, serial_logic):
        super().__init__()
        self.serial_logic = serial_logic
        self.levels = [
            {"id": 1, "texto": "Fase 1: Menino + Sorvete = Feliz", "imagem": "assets/imagens/mewing.jpeg", "resposta": "444"},
            {"id": 2, "texto": "Fase 2: Menina + Balão = Alegre", "imagem": "assets/imagens/GG.jpg", "resposta": "444"},
            {"id": 3, "texto": "Fase 3: Menino + Chuva = Triste", "imagem": "assets/imagens/meta.jpg", "resposta": "444"},
        ]
        self.current_level = 0
        self.timer = QTimer()
        self.timer.timeout.connect(self.ler_dados)
        self.game_on = False 

    def start_game(self):
        """Ativa o jogo e inicia o primeiro nível"""
        if not self.game_on:
            self.game_on = True
            self.current_level = 0
            self.start_level(1)

    def start_level(self, level_num=1):
        """Inicia o nível desejado"""
        self.current_level = level_num - 1
        level = self.levels[self.current_level]
        print(f"Iniciando {level['texto']}")
        self.next_level_signal.emit(level["id"], level["texto"], level['imagem'])
        self.timer.start(200)

    def ler_dados(self):
        """Lê o serial e verifica resposta"""
        data = self.serial_logic.read_serial()
        if not data:
            return

        print("Recebido:", data)
        dado = self.filtrar_dado(data)
        print("Tratado: ", dado)
        expected = self.levels[self.current_level]["resposta"]

        self.serial_logic.send_serial(dado)

        if dado.strip() == expected:
            print("✅ Resposta correta!")
            self.timer.stop()
            self.mostrar_acertou()
        else:
            print("❌ Resposta incorreta.")
            self.mostrar_errou()
        

    def avancar_nivel(self):
        """Passa para o próximo nível"""
        self.current_level += 1
        if self.current_level < len(self.levels):
            next_level = self.levels[self.current_level]
            self.next_level_signal.emit(next_level["id"], next_level["texto"], next_level['imagem'])
            self.timer.start(200)
        else:
            print("🎉 Jogo concluído!")
            self.ganhou_jogo()

    def mostrar_acertou(self):
        """Apresenta tela de acerto"""
        self.correct_answer_signal.emit("🎉 Acertou!", "assets/imagens/mewing.jpeg")
        QTimer.singleShot(1000, self.avancar_nivel)

    def mostrar_errou(self):
        """Apresenta tela de erro"""
        self.wrong_answer_signal.emit("Quase lá, tente novamente!", "assets/imagens/foi mal.jpg")
        QTimer.singleShot(1000, lambda: self.start_level(self.current_level+1))

    def ganhou_jogo(self):
        """Indica vitória do jogo"""
        self.game_on = False
        self.win_game_signal.emit()

    def discretizar(self, valor):
        """Discretiza o valor recebido"""
        val = int(valor)
        if val <= 10:
            return "1"
        elif 20 <= val <= 30:
            return "2"
        elif 40 <= val <= 50:
            return "3"
        else:
            return "4"

    def filtrar_dado(self, dado):
        """Filtra e discretiza os valores recebidos"""
        valores = dado.split('#')
        filtrado = [self.discretizar(val) for val in valores if val]
        return "".join(filtrado)

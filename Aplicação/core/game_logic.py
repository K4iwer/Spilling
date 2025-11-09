from PyQt6.QtCore import QObject, QTimer, pyqtSignal, Qt

class GameLogic(QObject):
    next_level_signal = pyqtSignal(int, str, str)  # envia número e descrição da fase
    correct_answer_signal = pyqtSignal(str, str)   # envia mensagem de acerto
    wrong_answer_signal = pyqtSignal(str, str)   # envia mensagem de erro
    win_game_signal = pyqtSignal()

    def __init__(self, serial_logic):
        super().__init__()
        self.serial_logic = serial_logic
        self.levels = [
            {"id": 1,  "texto": "Fase 1: Menino + Sorvete = Feliz",     "imagem": "assets/imagens/fases/fase1.png",  "resposta": "111"},
            {"id": 2,  "texto": "Fase 2: Menina + Chuva = Triste",      "imagem": "assets/imagens/fases/fase2.png",  "resposta": "232"},
            {"id": 3,  "texto": "Fase 3: Cachorro + Brinquedo = Feliz", "imagem": "assets/imagens/fases/fase3.png",  "resposta": "341"},
            {"id": 4,  "texto": "Fase 4: Robô + Chuva = Assustado",     "imagem": "assets/imagens/fases/fase4.png",  "resposta": "434"},
            {"id": 5,  "texto": "Fase 5: Descubra pelo contexto!",      "imagem": "assets/imagens/fases/fase5.png",  "resposta": "143"},
            {"id": 6,  "texto": "Fase 6: Descubra pelo contexto!",      "imagem": "assets/imagens/fases/fase6.png",  "resposta": "212"},
            {"id": 7,  "texto": "Fase 7: Descubra pelo contexto!",      "imagem": "assets/imagens/fases/fase7.png",  "resposta": "333"},
            {"id": 8,  "texto": "Fase 8: Descubra pelo contexto!",      "imagem": "assets/imagens/fases/fase8.png",  "resposta": "421"},
            {"id": 9,  "texto": "Fase 9: Menino + Sorvete = ?",         "imagem": "assets/imagens/fases/fase9.png",  "resposta": "111"},
            {"id": 10, "texto": "Fase 10: Menina + ? = Assustada",      "imagem": "assets/imagens/fases/fase10.png", "resposta": "223"},
            {"id": 11, "texto": "Fase 11: Cachorro + Brinquedo = ?",    "imagem": "assets/imagens/fases/fase11.png", "resposta": "341"},
            {"id": 12, "texto": "Fase 12: Robô + Chuva = Assustado",    "imagem": "assets/imagens/fases/fase12.png", "resposta": "434"},
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

    def voltar_nivel(self):
        """Passa para o próximo nível"""
        self.current_level -= 1
        if self.current_level >= 0:
            next_level = self.levels[self.current_level]
            self.next_level_signal.emit(next_level["id"], next_level["texto"], next_level['imagem'])
            self.timer.start(200)
        else:
            print("Dá n fí")

    def mostrar_acertou(self):
        """Apresenta tela de acerto"""
        self.correct_answer_signal.emit("🎉 Acertou!", "assets/imagens/feedback/acertou.png")
        QTimer.singleShot(1000, self.avancar_nivel)

    def mostrar_errou(self):
        """Apresenta tela de erro"""
        self.wrong_answer_signal.emit("Quase lá, tente novamente!", "assets/imagens/feedback/errou.png")
        QTimer.singleShot(1000, lambda: self.start_level(self.current_level+1))

    def ganhou_jogo(self):
        """Indica vitória do jogo"""
        self.game_on = False
        self.win_game_signal.emit()

    def discretizar(self, valor):
        """Discretiza o valor recebido"""
        try:
            val = int(valor)
        except (ValueError, TypeError):
            return
        
        if val <= 80:
            return "1"
        elif 90 <= val <= 100:
            return "2"
        elif 140 <= val <= 200:
            return "3"
        else:
            return "4"

    def filtrar_dado(self, dado):   
        """Filtra e discretiza os valores recebidos, tratando qualquer tipo de erro"""
        try:
            # Garante que dado seja uma string
            if dado is None:
                return ""
            if not isinstance(dado, str):
                dado = str(dado)
            
            # Divide e discretiza
            valores = dado.split('#')
            filtrado = []
            for val in valores:
                if not val:
                    continue
                try:
                    res = self.discretizar(val)
                    filtrado.append(str(res) if res is not None else "")
                except Exception:
                    filtrado.append("")  # ignora valores problemáticos

            return "".join(filtrado)

        except Exception:
            # Se algo inesperado acontecer, retorna string vazia
            return ""
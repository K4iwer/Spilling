from PyQt6.QtWidgets import QApplication, QStackedWidget
from UI.tela_inicial import TelaInicial
from UI.tela_jogo import TelaJogo
from PyQt6.QtCore import Qt
import sys
from core.serial_manager import SerialLogic

class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()

        self.serial_logic = SerialLogic()

        # Cria as telas
        self.tela_inicial = TelaInicial(self.serial_logic)
        self.tela_jogo = TelaJogo(self.serial_logic)

        # Adiciona ao QStackedWidget
        self.addWidget(self.tela_inicial)
        self.addWidget(self.tela_jogo)

        # Define tela inicial
        self.setCurrentWidget(self.tela_inicial)

        # Conecta o sinal de início do jogo
        self.tela_inicial.start_game_signal.connect(self.abrir_jogo)

        # Voltar ao menu
        self.tela_jogo.voltar_menu_signal.connect(self.abrir_menu)

    def abrir_jogo(self):
        self.setCurrentWidget(self.tela_jogo)
        self.tela_jogo.game_logic.start_game()

    def abrir_menu(self):
        self.setCurrentWidget(self.tela_inicial)

    def keyPressEvent(self, event):
        if event.key() == Qt.Key.Key_Escape:
            self.showNormal()  # volta pro modo janela

if __name__ == "__main__":
    app = QApplication(sys.argv)

    with open("assets/style.qss", "r", encoding="utf-8") as f:
        app.setStyleSheet(f.read())

    window = MainWindow()
    window.showFullScreen()
    sys.exit(app.exec())

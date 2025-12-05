from PyQt6.QtWidgets import QApplication, QStackedWidget
from UI.tela_inicial import TelaInicial
from UI.tela_jogo import TelaJogo
from UI.tela_tutorial import TelaTutorial
from UI.tela_vitoria import TelaVitoria
from PyQt6.QtCore import Qt
import sys
from core.serial_manager import SerialLogic
from PyQt6.QtWidgets import QColorDialog


class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()

        self.setObjectName("janelaPrincipal")

        self.serial_logic = SerialLogic()

        # Cria as telas
        self.tela_inicial = TelaInicial(self.serial_logic)
        self.tela_jogo = TelaJogo(self.serial_logic)
        self.tela_tutorial = TelaTutorial()
        self.tela_vitoria = TelaVitoria()

        # Adiciona ao QStackedWidget
        self.addWidget(self.tela_inicial)
        self.addWidget(self.tela_jogo)
        self.addWidget(self.tela_tutorial)
        self.addWidget(self.tela_vitoria)

        # Define tela inicial
        self.setCurrentWidget(self.tela_inicial)

        # Conecta o sinal de início do jogo
        self.tela_inicial.start_game_signal.connect(self.abrir_jogo)

        # Abrir tutorial
        self.tela_inicial.open_tutorial_signal.connect(self.abrir_tutorial)

        # Conecta sinal de vitória
        self.tela_jogo.game_logic.win_game_signal.connect(self.abrir_vitoria)

        # Voltar ao menu
        self.tela_jogo.voltar_menu_signal.connect(self.abrir_menu)
        self.tela_tutorial.voltar_menu_signal.connect(self.abrir_menu)
        self.tela_vitoria.voltar_menu_signal.connect(self.abrir_menu)
        self.tela_inicial.color_signal.connect(self.abrir_seletor_cor)

    def abrir_jogo(self):
        self.setCurrentWidget(self.tela_jogo)
        self.tela_jogo.game_logic.start_game()

    def abrir_menu(self):
        self.setCurrentWidget(self.tela_inicial)

    def abrir_tutorial(self):
        self.setCurrentWidget(self.tela_tutorial)

    def abrir_vitoria(self):
        self.setCurrentWidget(self.tela_vitoria)

    def keyPressEvent(self, event):
        if event.key() == Qt.Key.Key_Escape:
            if self.isFullScreen():
                self.showNormal()
            else:
                self.showFullScreen()

        elif event.key() == Qt.Key.Key_V:
            if self.currentWidget() == self.tela_jogo:
                self.tela_jogo.game_logic.avancar_nivel()

        elif event.key() == Qt.Key.Key_L:
            if self.currentWidget() == self.tela_jogo:
                self.tela_jogo.game_logic.voltar_nivel()
        
        super().keyPressEvent(event)

    def mudar_cor_fundo(self, cor):
        estilo = f"""
            QStackedWidget#janelaPrincipal {{
                background-color: {cor};
            }}
        """
        
        self.setStyleSheet(estilo)

    def abrir_seletor_cor(self):
        from PyQt6.QtWidgets import QDialog, QPushButton, QHBoxLayout
        
        dialog = QDialog(self)
        dialog.setWindowTitle("Cor de Fundo")
        layout = QHBoxLayout()

        cores = ["#ECE9DE", "#ffffff", "#cccccc", "#aaaaaa", "#888888",
                "#ff9999", "#99ccff", "#ccffcc", "#ffff99"]

        for c in cores:
            btn = QPushButton()
            btn.setFixedSize(40, 40)
            btn.setStyleSheet(f"background-color: {c}; border-radius: 5px;")
            btn.clicked.connect(lambda _, cor=c: (self.mudar_cor_fundo(cor), dialog.accept()))
            layout.addWidget(btn)

        dialog.setLayout(layout)
        dialog.exec()

if __name__ == "__main__":
    app = QApplication(sys.argv)

    with open("assets/style.qss", "r", encoding="utf-8") as f:
        app.setStyleSheet(f.read())

    window = MainWindow()
    window.showFullScreen()
    sys.exit(app.exec())

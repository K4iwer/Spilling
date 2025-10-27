from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton
from PyQt6.QtCore import Qt, pyqtSignal
from core.game_logic import GameLogic

class TelaJogo(QWidget):
    voltar_menu_signal = pyqtSignal()

    def __init__(self, serial_logic):
        super().__init__()

        # Elementos da interface
        self.label_fase = QLabel("Clique em Iniciar para começar")
        self.label_fase.setAlignment(Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignHCenter)

        self.btn_voltar = QPushButton("Voltar ao Menu")
        self.btn_voltar.clicked.connect(self.voltar_menu_signal.emit)
        self.btn_voltar.setMaximumWidth(500)
        self.btn_voltar.setMinimumHeight(60)

        # Layout
        layout = QVBoxLayout()
        layout.addSpacing(300)
        layout.addWidget(self.label_fase)
        layout.addSpacing(200)
        layout.addWidget(self.btn_voltar, alignment=Qt.AlignmentFlag.AlignCenter)
        self.setLayout(layout)

        # Game Logic
        self.game_logic = GameLogic(serial_logic)
        self.game_logic.correct_answer_signal.connect(self.mostrar_acertou)
        self.game_logic.next_level_signal.connect(self.atualizar_fase)
        self.game_logic.start_level(1)

    def atualizar_fase(self, id, texto):
        self.label_fase.setText(texto)

    def mostrar_acertou(self, menssagem):
        self.label_fase.setText(menssagem)


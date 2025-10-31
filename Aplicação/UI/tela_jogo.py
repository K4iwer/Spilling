from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton, QProgressBar
from PyQt6.QtCore import Qt, pyqtSignal
from core.game_logic import GameLogic
from PyQt6.QtGui import QPixmap

class TelaJogo(QWidget):
    voltar_menu_signal = pyqtSignal()

    def __init__(self, serial_logic):
        super().__init__()

        # Elementos da interface
        self.label_fase = QLabel("Clique em Iniciar para começar")
        self.label_fase.setAlignment(Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignHCenter)

        self.image_label = QLabel()
        self.image_label.setAlignment(Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignHCenter)

        self.progress_bar = QProgressBar()
        self.progress_bar.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.progress_bar.setFixedHeight(50)
        self.progress_bar.setTextVisible(True)

        self.btn_voltar = QPushButton("Voltar ao Menu")
        self.btn_voltar.clicked.connect(self.voltar_menu_signal.emit)
        self.btn_voltar.setMaximumWidth(500)
        self.btn_voltar.setMinimumHeight(60)

        # Layout
        layout = QVBoxLayout()
        layout.addStretch()
        layout.addWidget(self.label_fase)
        layout.addWidget(self.image_label)
        layout.addStretch()
        layout.addWidget(self.progress_bar, alignment=Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(self.btn_voltar, alignment=Qt.AlignmentFlag.AlignCenter)
        layout.addStretch()
        self.setLayout(layout)

        # Game Logic
        self.game_logic = GameLogic(serial_logic)
        self.game_logic.correct_answer_signal.connect(self.mostrar_acertou)
        self.game_logic.wrong_answer_signal.connect(self.mostrar_errou)
        self.game_logic.next_level_signal.connect(self.atualizar_fase)

    def atualizar_fase(self, id, texto, imagem):
        # label
        self.label_fase.setText(texto)

        # imagem
        pixmap = QPixmap(imagem)
        self.image_label.setPixmap(pixmap.scaled(
            400, 400, 
            Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.SmoothTransformation
        ))

        # barra de progreso
        total_levels = len(self.game_logic.levels)
        progress = int((id / total_levels) * 100)
        self.progress_bar.setValue(progress)
        self.progress_bar.setFormat(f"Nível {id} de {total_levels}")

    def mostrar_acertou(self, mensagem, imagem):
        self.label_fase.setText(mensagem)

        pixmap = QPixmap(imagem)
        self.image_label.setPixmap(pixmap.scaled(
            400, 400, 
            Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.SmoothTransformation
        ))

    def mostrar_errou(self, mensagem, imagem):
        self.label_fase.setText(mensagem)

        pixmap = QPixmap(imagem)
        self.image_label.setPixmap(pixmap.scaled(
            400, 400, 
            Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.SmoothTransformation
        ))


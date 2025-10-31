from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton
from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtGui import QPixmap

class TelaVitoria(QWidget):
    voltar_menu_signal = pyqtSignal()

    def __init__(self):
        super().__init__()

        # Elementos da interface
        self.label_vitoria = QLabel("Ganhou o jogo CARALHO!")
        self.label_vitoria.setAlignment(Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignHCenter)

        self.image_label = QLabel()
        self.image_label.setAlignment(Qt.AlignmentFlag.AlignCenter | Qt.AlignmentFlag.AlignHCenter)
        pixmap = QPixmap("assets/imagens/meandthebros.jpeg")
        self.image_label.setPixmap(pixmap.scaled(
            400, 400, 
            Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.SmoothTransformation
        ))
        
        self.btn_voltar = QPushButton("Voltar ao Menu")
        self.btn_voltar.clicked.connect(self.voltar_menu_signal.emit)
        self.btn_voltar.setMaximumWidth(500)
        self.btn_voltar.setMinimumHeight(60)

        # Layout
        layout = QVBoxLayout()
        layout.addStretch()
        layout.addWidget(self.label_vitoria)
        layout.addSpacing(200)
        layout.addWidget(self.image_label)
        layout.addSpacing(200)
        layout.addWidget(self.btn_voltar, alignment=Qt.AlignmentFlag.AlignCenter)
        layout.addStretch()

        self.setLayout(layout)



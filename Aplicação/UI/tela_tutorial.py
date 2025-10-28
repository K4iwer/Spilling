from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton
from PyQt6.QtCore import Qt, pyqtSignal


class TelaTutorial(QWidget):
    voltar_menu_signal = pyqtSignal()

    def __init__(self):
        super().__init__()

        # Elementos da interface
        self.label_tutorial = QLabel("Tutorial do jogo")
        self.label_tutorial.setAlignment(Qt.AlignmentFlag.AlignHCenter)

        self.label_expl = QLabel("O jogo consiste ...")
        self.label_expl.setAlignment(Qt.AlignmentFlag.AlignHCenter)

        self.btn_voltar = QPushButton("Voltar ao Menu")
        self.btn_voltar.clicked.connect(self.voltar_menu_signal.emit)
        self.btn_voltar.setMaximumWidth(500)
        self.btn_voltar.setMinimumHeight(60)

        # Layout
        layout = QVBoxLayout()
        layout.addStretch()
        layout.addWidget(self.label_tutorial)
        layout.addSpacing(200)
        layout.addWidget(self.label_expl)
        layout.addSpacing(200)
        layout.addWidget(self.btn_voltar, alignment=Qt.AlignmentFlag.AlignCenter)
        layout.addStretch()

        self.setLayout(layout)


from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton, QScrollArea
from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtGui import QFont


class TelaTutorial(QWidget):
    voltar_menu_signal = pyqtSignal()

    def __init__(self):
        super().__init__()

        # Elementos da interface
        self.label_expl = QLabel("""
            <p style="line-height: 1.6;">
            <b>Bem-vindo ao Spilling!</b><br><br>

            Neste jogo, você irá avançar por diferentes fases combinando
            <b>um personagem</b> com <b>uma situação</b> para alcançar o 
            <b>estado emocional correto</b>.<br><br>

            <b>Como jogar:</b><br>
            1. Escolha o personagem, a situação e a emoção posicionando o suporte na área indicada.<br>
            2. Aperte o botão de jogada na estrutura física<br>
            3. Observe sua jogada pelos discos e a resposta do jogo pela tela<br>

            Divirta-se explorando emoções, raciocínio e criatividade!
            </p>
        """)

        self.label_expl.setWordWrap(True)
        self.label_expl.setAlignment(Qt.AlignmentFlag.AlignJustify)
        self.label_expl.setFont(QFont("Arial", 14))
        self.label_expl.setAlignment(Qt.AlignmentFlag.AlignHCenter)

        self.btn_voltar = QPushButton("Voltar ao Menu")
        self.btn_voltar.clicked.connect(self.voltar_menu_signal.emit)
        self.btn_voltar.setMaximumWidth(500)
        self.btn_voltar.setMinimumHeight(60)

        # Layout
        layout = QVBoxLayout()
        layout.addStretch()
        layout.addWidget(self.label_expl)
        layout.addStretch()
        layout.addWidget(self.btn_voltar, alignment=Qt.AlignmentFlag.AlignCenter)
        layout.addStretch()

        self.setLayout(layout)


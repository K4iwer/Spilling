from PyQt6.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QLabel
from PyQt6.QtCore import pyqtSignal, Qt
from .tela_config_serial import SerialConfigDialog
from PyQt6.QtWidgets import QLabel
from PyQt6.QtGui import QPixmap
from PyQt6.QtWidgets import QColorDialog

class TelaInicial(QWidget):
    start_game_signal = pyqtSignal()  # sinal emitido ao clicar em "Iniciar Jogo"
    open_tutorial_signal = pyqtSignal()  # sinal emitido ao clicar em "Tutorial"
    color_signal = pyqtSignal()  # envia cor escolhida

    def __init__(self, serial_logic):
        super().__init__()
        self.serial_logic = serial_logic    

        self.setObjectName("paginaStack")

        # Elementos da interface
        self.label = QLabel("Bem-vindo ao jogo sério (time to lock in)")
        self.label.setObjectName("titulo")
        self.label.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.btn_iniciar = QPushButton("▶ Iniciar Jogo")
        self.btn_iniciar.setMaximumWidth(500)
        self.btn_iniciar.setMinimumHeight(60)

        self.btn_config_serial = QPushButton("⚙ Configurar Porta Serial")
        self.btn_config_serial.setMaximumWidth(500)
        self.btn_config_serial.setMinimumHeight(60)

        self.btn_tutorial = QPushButton("📖 Tutorial")
        self.btn_tutorial.setMaximumWidth(500)
        self.btn_tutorial.setMinimumHeight(60)

        self.btn_cor = QPushButton("🎨 Mudar Cor")
        self.btn_cor.setMaximumWidth(500)
        self.btn_cor.setMinimumHeight(60)

        # Ligações dos botões
        self.btn_iniciar.clicked.connect(self.start_game_signal.emit)
        self.btn_config_serial.clicked.connect(self.abrir_config_serial)
        self.btn_tutorial.clicked.connect(self.open_tutorial_signal.emit)
        self.btn_cor.clicked.connect(self.color_signal.emit)

        # Layout horizontal (botões)
        layout_but = QHBoxLayout()
        layout_but.addStretch()
        layout_but.addWidget(self.btn_iniciar)
        layout_but.addSpacing(30)
        layout_but.addWidget(self.btn_config_serial)
        layout_but.addSpacing(30)
        layout_but.addWidget(self.btn_tutorial)
        layout_but.addSpacing(30)
        layout_but.addWidget(self.btn_cor)
        layout_but.addStretch()

        # Layout principal (vertical)
        layout_text = QVBoxLayout()
        layout_text.addStretch()
        layout_text.addWidget(self.label, alignment=Qt.AlignmentFlag.AlignTop | Qt.AlignmentFlag.AlignHCenter)
        layout_text.addStretch()
        layout_text.addLayout(layout_but) 
        layout_text.addStretch()

        self.setLayout(layout_text)

    def abrir_config_serial(self):
        dialog = SerialConfigDialog(self.serial_logic)
        dialog.exec()  # abre o popup modal    

from PyQt6.QtWidgets import QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QLabel
from PyQt6.QtCore import pyqtSignal, Qt
from .tela_config_serial import SerialConfigDialog

class TelaInicial(QWidget):
    start_game_signal = pyqtSignal()  # sinal emitido ao clicar em "Iniciar Jogo"

    def __init__(self, serial_logic):
        super().__init__()
        self.serial_logic = serial_logic    

        # Elementos da interface
        self.label = QLabel("Bem-vindo ao jogo sério (time to lock in)")
        self.label.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.btn_iniciar = QPushButton("▶ Iniciar Jogo")
        self.btn_iniciar.setMaximumWidth(500)
        self.btn_iniciar.setMinimumHeight(60)

        self.btn_config_serial = QPushButton("⚙ Configurar Porta Serial")
        self.btn_config_serial.setMaximumWidth(500)
        self.btn_config_serial.setMinimumHeight(60)

        # Ligações dos botões
        self.btn_iniciar.clicked.connect(self.start_game_signal.emit)
        self.btn_config_serial.clicked.connect(self.abrir_config_serial)

        # Layout horizontal (botões)
        layout_but = QHBoxLayout()
        layout_but.addStretch()
        layout_but.addWidget(self.btn_iniciar)
        layout_but.addSpacing(30)
        layout_but.addWidget(self.btn_config_serial)
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

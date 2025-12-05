from PyQt6.QtWidgets import QDialog, QVBoxLayout, QLabel, QPushButton, QComboBox

class SerialConfigDialog(QDialog):
    def __init__(self, serial_logic):
        super().__init__()
        self.setWindowTitle("Configuração da Porta Serial")

        self.serial_logic = serial_logic
        layout = QVBoxLayout()

        self.label = QLabel("Selecione a porta COM:")
        self.combo_ports = QComboBox()
        self.btn_refresh = QPushButton("Atualizar")
        self.btn_ok = QPushButton("Confirmar")

        layout.addWidget(self.label)
        layout.addWidget(self.combo_ports)
        layout.addWidget(self.btn_refresh)
        layout.addWidget(self.btn_ok)
        self.setLayout(layout)

        self.btn_refresh.clicked.connect(self.listar_portas)
        self.btn_ok.clicked.connect(self.conectar_serial)

        self.listar_portas()

    def listar_portas(self):
        self.combo_ports.clear()
        ports = self.serial_logic.list_ports()
        self.combo_ports.addItems(ports)
        if not ports:
            self.label.setText("Nenhuma porta encontrada")

    def conectar_serial(self):
        port = self.combo_ports.currentText()
        ok, msg = self.serial_logic.connect(port)
        self.label.setText(msg)

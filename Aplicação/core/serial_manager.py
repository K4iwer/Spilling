import serial
import serial.tools.list_ports

class SerialLogic:
    def __init__(self):
        self.ser = None
        self.selected_port = None

    def list_ports(self):
        """Lista as portas COM disponíveis."""
        ports = serial.tools.list_ports.comports()
        return [port.device for port in ports]

    def connect(self, port_name: str):
        """Tenta conectar à porta especificada."""
        try:
            self.ser = serial.Serial(
                port=port_name,
                baudrate=115200,
                bytesize=serial.SEVENBITS,
                parity=serial.PARITY_EVEN,
                stopbits=serial.STOPBITS_ONE,
                timeout=1
            )
            self.selected_port = port_name
            return True, f"✅ Conectado em {port_name}"
        except Exception as e:
            return False, f"❌ Erro ao conectar: {e}"

    def read_serial(self):
        """Lê uma linha da porta serial, se disponível."""
        try: 
            if self.ser and self.ser.in_waiting > 0:
                data = self.ser.readline().decode(errors='ignore').strip()
                return data
        except Exception as e:
            return f"Erro na leitura: {e}"

    def close(self):
        """Fecha a porta serial."""
        if self.ser:
            self.ser.close()
            self.ser = None

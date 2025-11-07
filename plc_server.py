#!/usr/bin/env python3
"""
PLC Communication Server using python-snap7

Provides HTTP REST API for Flutter app to communicate with Siemens S7 PLCs
"""

import snap7
from snap7.util import get_bool, get_real, get_int, set_bool, set_real, set_int
import time
import logging
from typing import Dict, Any, Optional
from flask import Flask, request, jsonify
from flask_cors import CORS
import threading

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

# Global PLC client
plc_client: Optional[snap7.client.Client] = None
plc_lock = threading.Lock()


class PLCClient:
    """S7 PLC Communication Client"""

    def __init__(self, ip: str = '192.168.7.2', rack: int = 0, slot: int = 1):
        self.ip = ip
        self.rack = rack
        self.slot = slot
        self.client = snap7.client.Client()
        self.connected = False
        self.last_error = ""
        self.max_retries = 3
        self.retry_delay = 1.0

    def connect(self) -> bool:
        """Connect to PLC with retry logic"""
        try:
            if self.connected and self.client.get_connected():
                return True

            logger.info(f"Connecting to PLC at {self.ip}, rack {self.rack}, slot {self.slot}")

            for attempt in range(self.max_retries):
                try:
                    self.client.connect(self.ip, self.rack, self.slot)
                    if self.client.get_connected():
                        self.connected = True
                        self.last_error = ""
                        logger.info(f"✅ Connected to S7 PLC at {self.ip}")
                        return True
                except Exception as e:
                    self.last_error = f"Connection error: {str(e)}"
                    logger.error(f"{self.last_error} (attempt {attempt + 1}/{self.max_retries})")
                    if attempt < self.max_retries - 1:
                        time.sleep(self.retry_delay)

            self.connected = False
            return False
        except Exception as e:
            self.last_error = f"Connection error: {str(e)}"
            logger.error(self.last_error)
            self.connected = False
            return False

    def disconnect(self):
        """Disconnect from PLC"""
        try:
            if self.connected:
                self.client.disconnect()
                self.connected = False
                logger.info("Disconnected from PLC")
        except Exception as e:
            logger.error(f"Error disconnecting: {e}")

    def is_connected(self) -> bool:
        """Check if connected to PLC"""
        return self.connected and self.client.get_connected()

    def get_status(self) -> Dict[str, Any]:
        """Get current PLC connection status"""
        return {
            'connected': self.is_connected(),
            'ip': self.ip,
            'rack': self.rack,
            'slot': self.slot,
            'last_error': self.last_error
        }

    def read_db_real(self, db_number: int, offset: int) -> Optional[float]:
        """Read REAL (float) value from data block"""
        try:
            if not self.is_connected():
                return None
            data = self.client.db_read(db_number, offset, 4)
            return get_real(data, 0)
        except Exception as e:
            self.last_error = f"Error reading DB{db_number}.DBD{offset}: {str(e)}"
            logger.error(self.last_error)
            return None

    def write_db_real(self, db_number: int, offset: int, value: float) -> bool:
        """Write REAL (float) value to data block"""
        try:
            if not self.is_connected():
                return False
            data = bytearray(4)
            set_real(data, 0, value)
            self.client.db_write(db_number, offset, data)
            return True
        except Exception as e:
            self.last_error = f"Error writing DB{db_number}.DBD{offset}: {str(e)}"
            logger.error(self.last_error)
            return False

    def read_db_bool(self, db_number: int, byte_offset: int, bit_offset: int) -> Optional[bool]:
        """Read BOOL value from data block"""
        try:
            if not self.is_connected():
                return None
            data = self.client.db_read(db_number, byte_offset, 1)
            return get_bool(data, 0, bit_offset)
        except Exception as e:
            self.last_error = f"Error reading DB{db_number}.DBX{byte_offset}.{bit_offset}: {str(e)}"
            logger.error(self.last_error)
            return None

    def write_db_bool(self, db_number: int, byte_offset: int, bit_offset: int, value: bool) -> bool:
        """Write BOOL value to data block"""
        try:
            if not self.is_connected():
                return False
            data = bytearray(self.client.db_read(db_number, byte_offset, 1))
            set_bool(data, 0, bit_offset, value)
            self.client.db_write(db_number, byte_offset, data)
            return True
        except Exception as e:
            self.last_error = f"Error writing DB{db_number}.DBX{byte_offset}.{bit_offset}: {str(e)}"
            logger.error(self.last_error)
            return False

    def read_db_int(self, db_number: int, offset: int) -> Optional[int]:
        """Read INT value from data block"""
        try:
            if not self.is_connected():
                return None
            data = self.client.db_read(db_number, offset, 2)
            return get_int(data, 0)
        except Exception as e:
            self.last_error = f"Error reading DB{db_number}.DBW{offset}: {str(e)}"
            logger.error(self.last_error)
            return None

    def write_db_int(self, db_number: int, offset: int, value: int) -> bool:
        """Write INT value to data block"""
        try:
            if not self.is_connected():
                return False
            data = bytearray(2)
            set_int(data, 0, value)
            self.client.db_write(db_number, offset, data)
            return True
        except Exception as e:
            self.last_error = f"Error writing DB{db_number}.DBW{offset}: {str(e)}"
            logger.error(self.last_error)
            return False

    def read_m_bit(self, byte_offset: int, bit_offset: int) -> Optional[bool]:
        """Read Merker (M memory) bit"""
        try:
            if not self.is_connected():
                return None
            data = self.client.mb_read(byte_offset, 1)
            return get_bool(data, 0, bit_offset)
        except Exception as e:
            self.last_error = f"Error reading M{byte_offset}.{bit_offset}: {str(e)}"
            logger.error(self.last_error)
            return None

    def write_m_bit(self, byte_offset: int, bit_offset: int, value: bool) -> bool:
        """Write Merker (M memory) bit"""
        try:
            if not self.is_connected():
                return False
            data = bytearray(self.client.mb_read(byte_offset, 1))
            set_bool(data, 0, bit_offset, value)
            self.client.mb_write(byte_offset, data)
            return True
        except Exception as e:
            self.last_error = f"Error writing M{byte_offset}.{bit_offset}: {str(e)}"
            logger.error(self.last_error)
            return False

    def read_area(self, area: str, db_number: int, start: int, size: int) -> Optional[bytes]:
        """Read raw bytes from PLC area"""
        try:
            if not self.is_connected():
                return None
            if area.upper() == 'DB':
                return bytes(self.client.db_read(db_number, start, size))
            elif area.upper() == 'INPUT':
                return bytes(self.client.eb_read(start, size))
            elif area.upper() == 'OUTPUT':
                return bytes(self.client.ab_read(start, size))
            elif area.upper() == 'MEMORY':
                return bytes(self.client.mb_read(start, size))
            return None
        except Exception as e:
            self.last_error = f"Error reading {area}: {str(e)}"
            logger.error(self.last_error)
            return None

    def write_area(self, area: str, db_number: int, start: int, data: bytes) -> bool:
        """Write raw bytes to PLC area"""
        try:
            if not self.is_connected():
                return False
            data_array = bytearray(data)
            if area.upper() == 'DB':
                self.client.db_write(db_number, start, data_array)
            elif area.upper() == 'INPUT':
                self.client.eb_write(start, data_array)
            elif area.upper() == 'OUTPUT':
                self.client.ab_write(start, data_array)
            elif area.upper() == 'MEMORY':
                self.client.mb_write(start, data_array)
            else:
                return False
            return True
        except Exception as e:
            self.last_error = f"Error writing {area}: {str(e)}"
            logger.error(self.last_error)
            return False


# Global PLC client instance
plc = PLCClient()


@app.route('/api/status', methods=['GET'])
def get_status():
    """Get PLC connection status"""
    with plc_lock:
        status = plc.get_status()
        return jsonify(status)


@app.route('/api/connect', methods=['POST'])
def connect():
    """Connect to PLC"""
    data = request.json
    ip = data.get('ip', '192.168.7.2')
    rack = data.get('rack', 0)
    slot = data.get('slot', 1)
    
    with plc_lock:
        plc.ip = ip
        plc.rack = rack
        plc.slot = slot
        success = plc.connect()
        
        return jsonify({
            'success': success,
            'status': plc.get_status()
        })


@app.route('/api/disconnect', methods=['POST'])
def disconnect():
    """Disconnect from PLC"""
    with plc_lock:
        plc.disconnect()
        return jsonify({'success': True, 'status': plc.get_status()})


@app.route('/api/read/db/real', methods=['POST'])
def read_db_real():
    """Read REAL from data block"""
    data = request.json
    db_number = data.get('db_number', 1)
    offset = data.get('offset', 0)
    
    with plc_lock:
        value = plc.read_db_real(db_number, offset)
        if value is None:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True, 'value': value})


@app.route('/api/write/db/real', methods=['POST'])
def write_db_real():
    """Write REAL to data block"""
    data = request.json
    db_number = data.get('db_number', 1)
    offset = data.get('offset', 0)
    value = data.get('value', 0.0)
    
    with plc_lock:
        success = plc.write_db_real(db_number, offset, value)
        if not success:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True})


@app.route('/api/read/db/bool', methods=['POST'])
def read_db_bool():
    """Read BOOL from data block"""
    data = request.json
    db_number = data.get('db_number', 1)
    byte_offset = data.get('byte_offset', 0)
    bit_offset = data.get('bit_offset', 0)
    
    with plc_lock:
        value = plc.read_db_bool(db_number, byte_offset, bit_offset)
        if value is None:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True, 'value': value})


@app.route('/api/write/db/bool', methods=['POST'])
def write_db_bool():
    """Write BOOL to data block"""
    data = request.json
    db_number = data.get('db_number', 1)
    byte_offset = data.get('byte_offset', 0)
    bit_offset = data.get('bit_offset', 0)
    value = data.get('value', False)
    
    with plc_lock:
        success = plc.write_db_bool(db_number, byte_offset, bit_offset, value)
        if not success:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True})


@app.route('/api/read/db/int', methods=['POST'])
def read_db_int():
    """Read INT from data block"""
    data = request.json
    db_number = data.get('db_number', 1)
    offset = data.get('offset', 0)
    
    with plc_lock:
        value = plc.read_db_int(db_number, offset)
        if value is None:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True, 'value': value})


@app.route('/api/write/db/int', methods=['POST'])
def write_db_int():
    """Write INT to data block"""
    data = request.json
    db_number = data.get('db_number', 1)
    offset = data.get('offset', 0)
    value = data.get('value', 0)
    
    with plc_lock:
        success = plc.write_db_int(db_number, offset, value)
        if not success:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True})


@app.route('/api/read/m/bit', methods=['POST'])
def read_m_bit():
    """Read M memory bit"""
    data = request.json
    byte_offset = data.get('byte_offset', 0)
    bit_offset = data.get('bit_offset', 0)
    
    with plc_lock:
        value = plc.read_m_bit(byte_offset, bit_offset)
        if value is None:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True, 'value': value})


@app.route('/api/write/m/bit', methods=['POST'])
def write_m_bit():
    """Write M memory bit"""
    data = request.json
    byte_offset = data.get('byte_offset', 0)
    bit_offset = data.get('bit_offset', 0)
    value = data.get('value', False)
    
    with plc_lock:
        success = plc.write_m_bit(byte_offset, bit_offset, value)
        if not success:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        return jsonify({'success': True})


@app.route('/api/read/area', methods=['POST'])
def read_area():
    """Read raw bytes from PLC area"""
    data = request.json
    area = data.get('area', 'DB')
    db_number = data.get('db_number', 1)
    start = data.get('start', 0)
    size = data.get('size', 1)
    
    with plc_lock:
        result = plc.read_area(area, db_number, start, size)
        if result is None:
            return jsonify({'success': False, 'error': plc.last_error}), 400
        # Convert bytes to base64 for JSON transport
        import base64
        return jsonify({
            'success': True,
            'data': base64.b64encode(result).decode('utf-8')
        })


@app.route('/api/write/area', methods=['POST'])
def write_area():
    """Write raw bytes to PLC area"""
    data = request.json
    area = data.get('area', 'DB')
    db_number = data.get('db_number', 1)
    start = data.get('start', 0)
    data_b64 = data.get('data', '')
    
    with plc_lock:
        import base64
        try:
            data_bytes = base64.b64decode(data_b64)
            success = plc.write_area(area, db_number, start, data_bytes)
            if not success:
                return jsonify({'success': False, 'error': plc.last_error}), 400
            return jsonify({'success': True})
        except Exception as e:
            return jsonify({'success': False, 'error': str(e)}), 400


@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'ok', 'service': 'PLC Communication Server'})


if __name__ == '__main__':
    print("=" * 60)
    print("PLC Communication Server (python-snap7)")
    print("=" * 60)
    print("Starting server on http://0.0.0.0:5000")
    print("Make sure python-snap7 is installed: pip install python-snap7")
    print("=" * 60)
    app.run(host='0.0.0.0', port=5000, debug=False)


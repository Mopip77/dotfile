#!/usr/bin/python3

import json
import os
import plistlib
import sys

ICON_PATH = "AirPods.widget/"
NO_BT_IMG = f'<img class="s-img" src="{ICON_PATH}case.png">'  # Icon for AirPods disconnected
AIRPD_PRODUCT_INDX = {
    8202: "airpodmax",
    8206: "airpodpro",
    8194: "airpod1",
    8207: "airpod2"
}


class AirPod:
    def __init__(self, ap: tuple):
        address, name, left, right, case, product_id, vendor_id = ap
        self.address = address
        self.name = name
        self.left = left
        self.right = right
        self.case = case
        self.product_id = product_id
        self.vendor_id = vendor_id
        self.product = AIRPD_PRODUCT_INDX.get(self.product_id) if self.product_id in AIRPD_PRODUCT_INDX else "n/a"


def paired_airpods() -> list:
    """
    Get list of connected AirPods

    Returns:
        list: Return AirPod Device Object-list with address, name, left/right battery
    """
    jsn: dict = json.loads(os.popen('system_profiler SPBluetoothDataType -json').read())
    devices: dict = jsn['SPBluetoothDataType'][0]['devices_list']
    connected_aps: list = list()
    for i in devices:
        for d_name, d_info in i.items():
            address: str = d_info.get('device_address')
            if d_info.get('device_connected') == "Yes" and 'device_productID' in d_info:
                ret = (
                    address,  # address
                    d_name,
                    d_info.get("device_batteryLevelLeft"),
                    d_info.get("device_batteryLevelRight"),
                    d_info.get("device_batteryLevelCase"),
                    int(d_info.get("device_productID"), 16),
                    int(d_info.get("device_vendorID"), 16)
                )
                airpod = AirPod(ret)
                # 76: Apple; 8206: AirPods Pro; 8194: AirPods 1; 8207: AirPods 2
                if airpod.vendor_id == 76 and airpod.product_id in AIRPD_PRODUCT_INDX:
                    connected_aps.append(airpod)
    return connected_aps


def get_device_html() -> list:
    """
    Generates list of devices incl name and battery status of Airpods

    Returns:
        list: List of HTML strings

    """
    airpods: list = paired_airpods()
    devices = list()
    for ap in airpods:
        left: str = f"L:{ap.left} " if ap.left else ""
        right: str = f"R:{ap.right} " if ap.right else ""
        case: str = f"C:{ap.case}" if ap.case else ""
        product: str = f'{ap.product}'
        name: str = ap.name
        d_str = name
        if left != "" or right != "":
            d_str = f"""
            <img src="{ICON_PATH}{product}.png">
            <div>{name}</div><span class="s-txt">{left} {right} {case}</span>
            """
        devices.append(d_str)
    return devices


def main():
    connected_list = get_device_html()
    connected = f'<div class="s-box">{NO_BT_IMG}<div style="font-size: 11pt;color: grey">AirPods not connected</div></div>'
    if len(connected_list) > 0:
        connected = "<br>".join(connected_list)
    sys.stdout.write(connected)


if __name__ == "__main__":
    main()

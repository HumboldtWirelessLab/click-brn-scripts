import xml.dom.minidom as dom
import shutil
import os
import sys


def exit_with_result(is_success, comment):
    print('Result: ' + comment)
    if is_success:
        sys.exit(0)
    sys.exit(1)


def success(comment):
    exit_with_result(True, comment)


def failed(comment):
    exit_with_result(False, comment)


def check_bridges(file_path, expected_bridges):
    found_bridges = get_list_of_found_bridges(file_path)
    print("Info: Found Bridges:")
    print_list(found_bridges)

    for bridge in expected_bridges:
        if not bridge in found_bridges:
            print("Error: Mising bridge {0}.".format(bridge))
            return False

    for bridge in found_bridges:
        if not bridge in expected_bridges:
            print("Error: Wrong bridge {0}.".format(bridge))
            return False

    return True


def print_list(elements):
    for element in elements:
        print("    {0} ".format(element))


def get_list_of_found_bridges(file_path):
    tree = dom.parse(file_path)

    result = []
    topoinfo_elements = tree.getElementsByTagName("topology_info")
    for element in topoinfo_elements:
        bridge_elements = element.getElementsByTagName("bridges")
        for element in bridge_elements:
            single_bridge_elements = element.getElementsByTagName("bridge")
            for element in single_bridge_elements:
                node_a = element.getAttribute("node_a").encode('utf-8')
                node_b = element.getAttribute("node_b").encode('utf-8')
                bridge = (node_a, node_b)
                if not bridge in result:
                    result.append(bridge)
    return result


def check_articulation_points(file_path, expected_articulation_nodes):
    tree = dom.parse(file_path)

    xml_elements = tree.getElementsByTagName("ArticulationPoint")
    found_articulation_nodes = get_list_of_articulation_nodes(xml_elements)
    print("Info: Found AP:")
    print_list(found_articulation_nodes)

    for ap in expected_articulation_nodes:
        if not ap in found_articulation_nodes:
            print("Error: Mising AP {0}.".format(ap))
            return False

    for ap in found_articulation_nodes:
        if not ap in expected_articulation_nodes:
            print("Error: Wrong AP {0}.".format(ap))
            return False

    return True


def get_list_of_articulation_nodes(xml_elements):
    result = []
    for element in xml_elements:
        node = element.getAttribute("node").encode('utf-8')
        result.append(node)
    return result


def copy_placement_file_if_missing(path_to_evaluate):
    expected_file_path = os.path.join(path_to_evaluate, "placementfile.plm")
    alternative_file_path = os.path.join(path_to_evaluate, "../placementfile.plm")

    if not os.path.exists(expected_file_path):
        if os.path.exists(alternative_file_path):
            print("Info: Copy placement file...")
            print("      ... From {0}".format(alternative_file_path))
            print("      ... to {0}.".format(expected_file_path))
            shutil.copyfile(alternative_file_path, expected_file_path)
        else:
            print("Error: Placementfile missing.")

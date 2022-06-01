import os
import sys
import re as ree
# tab -> \

# INFO:
# files should be named in specific way, for example:
#
# Death.wav or Death1.wav
# Pain1.wav
# Pain2.wav
# Pain3.wav
# etc ...


def get_name(string: str) -> str:
    return string.rsplit('.', maxsplit=1)[0]


def get_extension(string: str) -> str:
    return string.rsplit('.', maxsplit=1)[-1]


def get_ini_directory():
    string = directory
    string_list = list(string)
    length = len(string_list)

    find_str = ["e", "t", "r", "."]
    find_str_index = 0
    find_str_len = len(find_str)
    for i in range(length - 1, -1, -1):
        if find_str_index < find_str_len:
            if string_list[i] == find_str[find_str_index]:
                find_str_index += 1
        else:
            if string_list[i] == "\\":
                result = "".join(string_list[i + 1:length])
                result = result.replace("\\", "/")
                return result
    return False


def create_sound_container(name, count = 1):
    name_with_spaces = " ".join(ree.findall('[A-Z][a-z]+', name))

    # Special
    if count < 0:
        name_with_spaces += " " + str(-count)

    lines = [
        "\nCreateSoundContainer = SoundContainer",
        "\tPresetName = " + preset_name + name_with_spaces,
        "\tImmobile = " + str(immobile),
        "\tVolume = " + str(volume)
         ]

    if count > 1:
        # Multiple sounds
        for i in range(count):
            index = str(i + 1)
            lines.append("\t" + "AddSound = " + directory_ini + name + index + "." + sound_extensions[name + index])
    else:
        # Singular sound
        if count >= 0:
            if name in sound_extensions:
                lines.append("\t" + "AddSound = " + directory_ini + name + "." + sound_extensions[name])
            elif (name + "1") in sound_extensions:
                lines.append("\t" + "AddSound = " + directory_ini + name + "1" + "." + sound_extensions[name + "1"])
            else:
                print("Uh oh... Something went wrong with " + name + " !")
        # Special
        else:
            lines.append("\t" + "AddSound = " + directory_ini + name + "." + sound_extensions[name.rstrip(name[-len(str(count))])])

    return lines

def create_sound_containers(name, count):
    lines = []
    for i in range(1, count + 1, 1):
        lines += create_sound_container(name + str(i), -i)
    return lines

if __name__ == '__main__':
    # Setup
    allowed_extensions = ["wav", "ogg", "flac", "mp3"]

    # Get current directory
    directory = os.getcwd()

    # Get list of files in current folder
    files = os.listdir(directory)

    # Get ini directory
    directory_ini = get_ini_directory() + "/"
    print("\n Current directory: ", directory_ini)

    # Variables for captured files
    sounds = []
    sound_count = 0

    sound_groups = {}
    sound_extensions = {}

    # Arguments
    print("\n Input arguments:")
    immobile = int(input("Immobile: "))
    volume = 1#float(input("Volume: "))
    preset_name = str(input("Preset name: ")) + " "
    group_type = int(input("Grouping type (1 - grouped, 2 - container per sound): "))

    if not directory_ini:
        print("\n Invalid location! No rte module detected!")
        sys.exit(1)

    for file in files:
        extension = get_extension(file)
        if not extension in allowed_extensions:
            continue
        name = get_name(file)
        sounds.append(name)

        sound_extensions[name] = extension

        if name[-1].isnumeric():
            name_str = list(name)

            # Hacky ofc, remove only the last few numbers
            for i in range(len(name) - 1, -1, -1):
                if name[i].isnumeric():
                    name_str[i] = "&"
                else:
                    name_str = "".join(name_str).replace("&", "")
                    break

            if name_str in sound_groups:
                sound_groups[name_str] += 1
            else:
                sound_groups[name_str] = 1
        else:
            sound_groups[name] = 1

    sound_count = len(sounds)

    print("\n Found sounds:", sound_count)

    if sound_count < 1:
        print("\n No sounds found!")
        sys.exit(1)

    file_ini = open('Result.ini', 'wt')
    for sound_group in sound_groups:
        if group_type == 1:
            file_ini.write("\n".join(create_sound_container(sound_group, sound_groups[sound_group])))
        elif group_type == 2:
            file_ini.write("\n".join(create_sound_containers(sound_group, sound_groups[sound_group])))
        file_ini.write("\n")
        file_ini.write("\n")
    file_ini.close()

    print("\n Success!")
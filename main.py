import os
import shutil


class ErrFileNotFound(Exception):
    pass

class ErrNoFilesToTrack(Exception):
    pass

class ErrNoDotFileFound(Exception):
    pass

FILES_TO_TRACK = ['.zshrc', '.gitconfig', '.vimrc']
DIR_PATH = os.path.dirname(os.path.realpath(__file__))
HOME_DIR = os.path.expanduser('~')

def copy(src, dest):
    if not src:
        raise ErrFileNotFound

    if not dest:
        raise ErrFileNotFound

    shutil.copyfile(src, dest)


def link(src, dest):
    if not src:
        raise ErrFileNotFound

    if not dest:
        raise ErrFileNotFound

    os.symlink(src, dest)

def copylink(src, dest):
    copy(src, dest)
    delete(src)
    link(dest, src)

def backup(file):

    if not file:
        raise ErrFileNotFound

    shutil.copyfile(file, file + '.backup')

def delete(file):
    if not file:
        raise ErrFileNotFound

    os.remove(file)


def main():
    val = input("Do you want to bootstrap your OS? y, N: ")
    if val in ("yes", "y", "Y"):
        print("#### Bootstrapping your OS")
        os.system("./install.sh")


    print("#### Link your dot files!")

    for file in FILES_TO_TRACK:

        if not file.startswith('.'):
            raise ErrNoDotFileFound

        print(f"### {file} ###")
        backup(HOME_DIR + '/' + file)
        delete(HOME_DIR + '/' + file)
        link(DIR_PATH + '/' + file, HOME_DIR + '/' + file)


if __name__ == '__main__':
    main()




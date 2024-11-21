package data.game;

import logging.Logger;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class GameBoard {
    public GameBoard(int sizeX, int sizeY) {
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        cells = new int[sizeX][sizeY];
    }

    /**
     * @param markSN MARK1 | MARK2
     * @return false - нельзя установить отметку тк уже установлено
     */
    public boolean setMark(int x, int y, int markSN) {
        try {
            if (cells[x][y] == EMPTY_CELL) {
                cells[x][y] = markSN;
                totalMarks += 1;
                return true;
            }
        } catch (Exception e) {
            //Logger.log("Board.setMark()> x/y out of bounds");
            return false;
        }
        return false;
    }

    /**
     * доска полностью переполнена
     */
    public Boolean isFull() {
        return totalMarks >= sizeX * sizeY;
    }

    private int totalMarks = 0;

    /**
     * проверка победителя. EMPTY_CELL - нет победителя
     *
     * @return EMPTY_CELL | MARK1 | MARK2 отметка победителя либо нет победителя
     */
    public int getWinnerMarkSN() {
        // check rows and columns
        for (int i = 0; i < sizeX; i++) {
            if (cells[i][0] != EMPTY_CELL && cells[i][0] == cells[i][1] && cells[i][0] == cells[i][2]) {
                return cells[i][0];
            }
            if (cells[0][i] != EMPTY_CELL && cells[0][i] == cells[1][i] && cells[0][i] == cells[2][i]) {
                return cells[0][i];
            }
        }

        // check diagonals
        if (cells[0][0] != EMPTY_CELL && cells[0][0] == cells[1][1] && cells[0][0] == cells[2][2]) {
            return cells[0][0];
        }
        if (cells[0][2] != EMPTY_CELL && cells[0][2] == cells[1][1] && cells[0][2] == cells[2][0]) {
            return cells[0][2];
        }

        // no winner found
        return EMPTY_CELL;
    }


    public ArrayList<Integer> getData() {
        ArrayList<Integer> res = new ArrayList<Integer>();
        for (int i = 0; i < sizeX; i++) {
            for (int ii = 0; ii < sizeY; ii++) {
                res.add(cells[i][ii]);
            }
        }
        return res;
    }

    private final int[][] cells;
    private final int sizeX;
    private final int sizeY;
    public static final int EMPTY_CELL = 0;
    public static final int MARK1 = 1;
    public static final int MARK2 = 2;

    public static final int BOARD_IS_FULL = -1;

}

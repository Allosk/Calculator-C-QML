#include "calculated.h"
#include <QJSEngine>

Calculated::Calculated(QObject *parent) : QObject(parent) { }

void Calculated::calc(QString text) {
    QJSEngine engine;
    QJSValue result = engine.evaluate(text);

    if (result.isNumber()) {
        m_solution = result.toString();
    } else {
        m_solution = "Ошибка";
    }

    emit solutionChanged(m_solution);
}

QString Calculated::solution() {
    return m_solution;
}

void Calculated::clearSolution() {
    m_solution = "";  // Очищаем значение
    emit solutionChanged(m_solution);  // Сообщаем о изменении
}

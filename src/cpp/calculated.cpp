#include "calculated.h"
#include <QJSEngine>

Calculated::Calculated(QObject *parent) : QObject(parent) {}

void Calculated::calc(QString text) {
    if (m_expression != text) {
        m_expression = text;
        emit expressionChanged(m_expression);
    }
}

void Calculated::calculate() {
    QJSEngine engine;
    QJSValue result = engine.evaluate(m_expression);

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

QString Calculated::expression() const {
    return m_expression;
}

void Calculated::clearSolution() {
    m_solution = "";
    m_expression = "";
    emit solutionChanged(m_solution);
    emit expressionChanged(m_expression);
}

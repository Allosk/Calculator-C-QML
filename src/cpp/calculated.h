#pragma once

#include <QObject>

class Calculated : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString solution READ solution NOTIFY solutionChanged)
    Q_PROPERTY(QString expression READ expression NOTIFY expressionChanged)

public:
    Calculated(QObject *parent = nullptr);
    
    Q_INVOKABLE void calculate();
    Q_INVOKABLE void calc(QString text);
    Q_INVOKABLE void clearSolution();
    QString solution();
    QString expression() const;

signals:
    void solutionChanged(QString solution);
    void expressionChanged(QString expression);

private:
    QString m_solution;
    QString m_expression;
};



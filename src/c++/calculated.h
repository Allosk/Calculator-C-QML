#pragma once

#include <QObject>

class Calculated : public QObject
{
    Q_OBJECT
    Q_PROPERTY (QString solution READ solution NOTIFY solutionChanged)

public:
    Calculated(QObject *parent = nullptr);
    Q_INVOKABLE void calc(QString text);
    Q_INVOKABLE void clearSolution();
    QString solution();

signals:
    void solutionChanged(QString solution);

private:
    QString m_solution;

};



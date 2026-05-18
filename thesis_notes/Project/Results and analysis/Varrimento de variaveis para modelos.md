# Resultados do Super-Varrimento Combinatório para Identificação Paramétrica

Este documento reúne os resultados do varrimento massivo de combinações de rácios temporais adimensionais (incluindo os novos tempos de cauda lenta $t_{0.9}$, $t_{95}$, $t_{99}$) para a estimação da ordem fracionária ($\nu$) e do rácio de amortecimento ($\zeta$) através de aproximadores polinomiais de quarta ordem (`poly44`).

---

## 1. Análise por Cenário Dinâmico

### 1.1. Global (Todo o Espetro)
* **Pontos Totais Filtrados:** 6247

* **Identificação de $\nu$:**
  * **Sem dependência mútua:** $R^2 = 0.84802$ | Amostras: 5734 | Inputs: `[(t02-t01)/(t09-t08)]` e `[(t08-t02)/(t09-t08)]`
  * **Com dependência mútua (Zeta Real):** $R^2 = 0.99931$ | Amostras: 6082 | Inputs: `[t02/t08]` e `[zeta_real]`

* **Identificação de $\zeta$:**
  * **Sem dependência mútua:** $R^2 = 0.77432$ | Amostras: 5734 | Inputs: `[t01/t09]` e `[(t05-t02)/(t09-t08)]`
  * **Com dependência mútua (Nu Real):** $R^2 = 0.98157$ | Amostras: 6247 | Inputs: `[t01/t05]` e `[nu_real]`

---

### 1.2. Com Picos ($M_p > 10^{-5}$)
* **Pontos Totais Filtrados:** 3860

* **Identificação de $\nu$:**
  * **Sem dependência mútua:** $R^2 = 0.83187$ | Amostras: 3860 | Inputs: `[log(t01/t99)]` e `[t05/tp]`
  * **Com dependência mútua (Zeta Real):** $R^2 = 0.99896$ | Amostras: 3860 | Inputs: `[t05/t09]` e `[zeta_real]`

* **Identificação de $\zeta$:**
  * **Sem dependência mútua:** $R^2 = 0.88483$ | Amostras: 3860 | Inputs: `[log(t07/tp)]` e `[(t08-t05)/(t05-t02)]`
  * **Com dependência mútua (Nu Real):** $R^2 = 0.98623$ | Amostras: 3860 | Inputs: `[log(t01/tp)]` e `[nu_real]`

---

### 1.3. Sem Picos ($M_p \le 10^{-5}$)
* **Pontos Totais Filtrados:** 2387

* **Identificação de $\nu$:**
  * **Sem dependência mútua:** 
	  * $R^2 = 0.97242$ | Amostras: 1874 | Inputs: `[(t08-t05)/(t09-t08)]` e `[(t08-t02)/(t09-t08)]`
  * **Com dependência mútua (Zeta Real):** 
	  * $R^2 = 0.99932$ | Amostras: 2371 | Inputs: `[t02/t07]` e `[zeta_real]`

* **Identificação de $\zeta$:**
  * **Sem dependência mútua:** 
	  * $R^2 = 0.99248$ | Amostras: 900 | Inputs: `[log(t01/t05)]` e `[(t02-t01)/(t99-t95)]`
  * **Com dependência mútua (Nu Real):** 
	  * $R^2 = 0.99531$ | Amostras: 2387 | Inputs: `[t01/t02]` e `[nu_real]`

---

### 1.4. Zeta Baixo ($\zeta < 2$)
* **Pontos Totais Filtrados:** 2130

* **Identificação de $\nu$:**
  * **Sem dependência mútua:** $R^2 = 0.85808$ | Amostras: 2107 | Inputs: `[t02/t09]` e `[(t02-t01)/(t08-t02)]`
  * **Com dependência mútua (Zeta Real):** $R^2 = 0.99938$ | Amostras: 2107 | Inputs: `[t05/t09]` e `[zeta_real]`

* **Identificação de $\zeta$:**
  * **Sem dependência mútua:** $R^2 = 0.55652$ | Amostras: 2107 | Inputs: `[t01/t09]` e `[t02/t08]`
  * **Com dependência mútua (Nu Real):** $R^2 = 0.99460$ | Amostras: 2130 | Inputs: `[log(t02/t08)]` e `[nu_real]`

---

### 1.5. Zeta Alto ($\zeta \ge 2$)
* **Pontos Totais Filtrados:** 4117

* **Identificação de $\nu$:**
  * **Sem dependência mútua:** $R^2 = 0.99960$ | Amostras: 3627 | Inputs: `[t01/t07]` e `[t05/t09]`
  * **Com dependência mútua (Zeta Real):** $R^2 = 0.99974$ | Amostras: 3627 | Inputs: `[t05/t09]` e `[zeta_real]`

* **Identificação de $\zeta$:**
  * **Sem dependência mútua:** $R^2 = 0.94387$ | Amostras: 3385 | Inputs: `[log(t01/t08)]` e `[t05/t95]`
  * **Com dependência mútua (Nu Real):** $R^2 = 0.98354$ | Amostras: 4117 | Inputs: `[t01/t05]` e `[nu_real]`

---

## 2. Tabelas Resumo Comparativas

### 2.1. Desempenho na Estimação da Ordem Fracionária ($\nu$)

| Cenário Analisado | Pontos | R² (Independente) | Inputs Escolhidos (X1 e X2) | R² (Com Zeta Real) |
| :--- | :---: | :---: | :--- | :---: |
| **Global** | 6247 | 0.84802 | `[(t02-t01)/(t09-t08)]` , `[(t08-t02)/(t09-t08)]` | 0.99931 |
| **Com Picos** | 3860 | 0.83187 | `[log(t01/t99)]` , `[t05/tp]` | 0.99896 |
| **Sem Picos** | 2387 | **0.97242** | `[(t08-t05)/(t09-t08)]` , `[(t08-t02)/(t09-t08)]` | 0.99932 |
| **Zeta < 2** | 2130 | 0.85808 | `[t02/t09]` , `[(t02-t01)/(t08-t02)]` | 0.99938 |
| **Zeta >= 2** | 4117 | **0.99960** | `[t01/t07]` , `[t05/t09]` | 0.99974 |

### 2.2. Desempenho na Estimação do Rácio de Amortecimento ($\zeta$)

| Cenário Analisado | Pontos | R² (Independente) | Inputs Escolhidos (X1 e X2) | R² (Com Nu Real) |
| :--- | :---: | :---: | :--- | :---: |
| **Global** | 6247 | 0.77432 | `[t01/t09]` , `[(t05-t02)/(t09-t08)]` | 0.98157 |
| **Com Picos** | 3860 | **0.88483** | `[log(t07/tp)]` , `[(t08-t05)/(t05-t02)]` | 0.98623 |
| **Sem Picos** | 2387 | **0.99248** | `[log(t01/t05)]` , `[(t02-t01)/(t99-t95)]` | 0.99531 |
| **Zeta < 2** | 2130 | *0.55652* | `[t01/t09]` , `[t02/t08]` | 0.99460 |
| **Zeta >= 2** | 4117 | **0.94387** | `[log(t01/t08)]` , `[t05/t95]` | 0.98354 |

---

## 3. Conclusões Chave para a Metodologia da Tese

1. **Validação do Critério de Segmentação por Overshoot:** O cenário **Zeta < 2** gerou o pior ajuste independente para o amortecimento ($R^2 = 0.55652$), confirmando que misturar sistemas oscilatórios e não-oscilatórios na mesma fronteira matemática quebra a continuidade da regressão. A divisão biológica por **Com Picos / Sem Picos** estabiliza as superfícies de ajuste, elevando o $R^2$ independente do amortecimento no regime não-oscilatório para uns impressionantes **0.99248**.
2. **Impacto dos Tempos de Cauda Fracionária:** A introdução de $t_{0.9}$, $t_{95}$ e $t_{99}$ foi crucial. O MATLAB escolheu predominantemente diferenças e razões baseadas em `t09-t08` e `t99-t95` para mapear o $\nu$ e o $\zeta$ nos regimes sem pico, provando empiricamente a teoria de que o efeito de memória longa dos sistemas de segunda espécie se manifesta com maior relevância na fase final de acomodação do sinal.

```
======================================================================== A PROCESSAR CENÁRIO: GLOBAL (TODO O ESPETRO) (Pontos Totais Filtrados: 6247) ========================================================================

[ IDENTIFICAÇÃO DE NU ] -> Sem dependência mútua: R² = 0.84802 | Amostras Usadas: 5734 | Inputs: [ (t02-t01)/ (t09-t08)] e [ (t08-t02)/ (t09-t08)] -> Com dependência mútua (Permitindo Zeta Real): R² = 0.99931 | Amostras Usadas: 6082 | Inputs: [t02/t08] e [zeta_real] [ IDENTIFICAÇÃO DE ZETA ] -> Sem dependência mútua: R² = 0.77432 | Amostras Usadas: 5734 | Inputs: [t01/t09] e [ (t05-t02)/ (t09-t08)] -> Com dependência mútua (Permitindo Nu Real): R² = 0.98157 | Amostras Usadas: 6247 | Inputs: [t01/t05] e [nu_real] ------------------------------------------------------------------------ ======================================================================== A PROCESSAR CENÁRIO: COM PICOS (MP > 1E-5) (Pontos Totais Filtrados: 3860) ========================================================================

[ IDENTIFICAÇÃO DE NU ] -> Sem dependência mútua: R² = 0.83187 | Amostras Usadas: 3860 | Inputs: [log(t01/t99)] e [t05/tp] -> Com dependência mútua (Permitindo Zeta Real): R² = 0.99896 | Amostras Usadas: 3860 | Inputs: [t05/t09] e [zeta_real] [ IDENTIFICAÇÃO DE ZETA ] -> Sem dependência mútua: R² = 0.88483 | Amostras Usadas: 3860 | Inputs: [log(t07/tp)] e [ (t08-t05)/ (t05-t02)] -> Com dependência mútua (Permitindo Nu Real): R² = 0.98623 | Amostras Usadas: 3860 | Inputs: [log(t01/tp)] e [nu_real] ------------------------------------------------------------------------ ======================================================================== A PROCESSAR CENÁRIO: SEM PICOS (MP <= 1E-5) (Pontos Totais Filtrados: 2387) ========================================================================

[ IDENTIFICAÇÃO DE NU ] -> Sem dependência mútua: R² = 0.97242 | Amostras Usadas: 1874 | Inputs: [ (t08-t05)/ (t09-t08)] e [ (t08-t02)/ (t09-t08)] -> Com dependência mútua (Permitindo Zeta Real): R² = 0.99932 | Amostras Usadas: 2371 | Inputs: [t02/t07] e [zeta_real] [ IDENTIFICAÇÃO DE ZETA ] -> Sem dependência mútua: R² = 0.99248 | Amostras Usadas: 900 | Inputs: [log(t01/t05)] e [ (t02-t01)/ (t99-t95)] -> Com dependência mútua (Permitindo Nu Real): R² = 0.99531 | Amostras Usadas: 2387 | Inputs: [t01/t02] e [nu_real] ------------------------------------------------------------------------ ======================================================================== A PROCESSAR CENÁRIO: ZETA < 2 (Pontos Totais Filtrados: 2130) ========================================================================

[ IDENTIFICAÇÃO DE NU ] -> Sem dependência mútua: R² = 0.85808 | Amostras Usadas: 2107 | Inputs: [t02/t09] e [ (t02-t01)/ (t08-t02)] -> Com dependência mútua (Permitindo Zeta Real): R² = 0.99938 | Amostras Usadas: 2107 | Inputs: [t05/t09] e [zeta_real] [ IDENTIFICAÇÃO DE ZETA ] -> Sem dependência mútua: R² = 0.55652 | Amostras Usadas: 2107 | Inputs: [t01/t09] e [t02/t08] -> Com dependência mútua (Permitindo Nu Real): R² = 0.99460 | Amostras Usadas: 2130 | Inputs: [log(t02/t08)] e [nu_real] ------------------------------------------------------------------------ ======================================================================== A PROCESSAR CENÁRIO: ZETA >= 2 (Pontos Totais Filtrados: 4117) ========================================================================

[ IDENTIFICAÇÃO DE NU ] -> Sem dependência mútua: R² = 0.99960 | Amostras Usadas: 3627 | Inputs: [t01/t07] e [t05/t09] -> Com dependência mútua (Permitindo Zeta Real): R² = 0.99974 | Amostras Usadas: 3627 | Inputs: [t05/t09] e [zeta_real] [ IDENTIFICAÇÃO DE ZETA ] -> Sem dependência mútua: R² = 0.94387 | Amostras Usadas: 3385 | Inputs: [log(t01/t08)] e [t05/t95] -> Com dependência mútua (Permitindo Nu Real): R² = 0.98354 | Amostras Usadas: 4117 | Inputs: [t01/t05] e [nu_real] ------------------------------------------------------------------------
```
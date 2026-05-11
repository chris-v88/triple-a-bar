import type { Drink } from '../types';

type Props = { drink: Drink };

const DrinkCard = ({ drink }: Props) => {
  return (
    <li className="drink-card">
      <h2 className="drink-name">{drink.name}</h2>

      <div className="drink-meta">
        <span className="meta-label">Glass</span>
        <span>{drink.glass.name}</span>
      </div>

      <div className="drink-meta">
        <span className="meta-label">Method</span>
        <span>{drink.method}</span>
      </div>

      {drink.garnish && (
        <div className="drink-meta">
          <span className="meta-label">Garnish</span>
          <span>{drink.garnish}</span>
        </div>
      )}

      <div className="drink-ingredients">
        <span className="meta-label">Ingredients</span>
        <ol>
          {drink.ingredients.map((di) => (
            <li key={di.id}>
              {[
                di.quantity,
                di.unit,
                di.ingredient.name,
                di.note ? `(${di.note})` : null,
              ]
                .filter(Boolean)
                .join(' ')}
            </li>
          ))}
        </ol>
      </div>
    </li>
  );
};
export default DrinkCard;

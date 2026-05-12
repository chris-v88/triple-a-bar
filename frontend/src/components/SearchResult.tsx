import type { Drink, Bottle } from '../types';
import DrinkCard from './DrinkCard';

type Props = {
  tab: string;
  query: string;
  loading: boolean;
  drinks: Drink[];
  bottles: Bottle[];
};

const SearchResult = ({ tab, query, loading, drinks, bottles }: Props) => {
  const trimmed = query.trim();

  if (!trimmed) return null;

  if (tab === 'drink') {
    if (loading) return null;
    if (drinks.length === 0) {
      return <p className="search-empty">No drinks found for "{trimmed}".</p>;
    }
    return (
      <ul className="results-list">
        {drinks.map((drink) => (
          <DrinkCard key={drink.id} drink={drink} />
        ))}
      </ul>
    );
  }

  if (tab === 'bottle') {
    if (loading) return null;
    if (bottles.length === 0) {
      return <p className="search-empty">No bottles found for "{trimmed}".</p>;
    }
    const category = bottles[0].category;
    return (
      <div>
        <div className="drink-card" style={{ marginBottom: '1rem' }}>
          <h2 className="drink-name">about {category.name.toLowerCase()}</h2>
          {category.description && (
            <p style={{ marginTop: '0.5rem', lineHeight: '1.6' }}>{category.description}</p>
          )}
        </div>
        <ul className="results-list">
        {bottles.map((bottle) => (
          <li key={bottle.id} className="drink-card">
            <h2 className="drink-name">{bottle.name}</h2>
            <div className="drink-meta">
              <span className="meta-label">Brand</span>
              <span>{bottle.brand.name}</span>
            </div>
            <div className="drink-meta">
              <span className="meta-label">Type</span>
              <span>{bottle.category.name}</span>
            </div>
            {bottle.abv && (
              <div className="drink-meta">
                <span className="meta-label">ABV</span>
                <span>{bottle.abv}%</span>
              </div>
            )}
            {bottle.proof && (
              <div className="drink-meta">
                <span className="meta-label">Proof</span>
                <span>{bottle.proof}</span>
              </div>
            )}
          </li>
        ))}
        </ul>
      </div>
    );
  }

  return null;
};

export default SearchResult;

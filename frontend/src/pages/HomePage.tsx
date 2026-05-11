import { useState, useEffect, useRef } from 'react';
import type { Drink } from '../types';
import { searchDrinks } from '../apis/drinks.api';
import SearchBar from '../components/SearchBar';
import DrinkCard from '../components/DrinkCard';
import TabSection from '../components/TabSection';

const HomePage = () => {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<Drink[]>([]);
  const [loading, setLoading] = useState(false);
  const [currentTab, setCurrentTab] = useState('drink');
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);

    const trimmed = query.trim();
    if (!trimmed) return;

    debounceRef.current = setTimeout(async () => {
      setLoading(true);
      try {
        const drinks = await searchDrinks(trimmed);
        setResults(drinks);
      } catch {
        setResults([]);
      } finally {
        setLoading(false);
      }
    }, 300);

    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, [query]);

  const displayResults = query.trim() ? results : [];

  return (
    <div className="app-container">
      <div className="flex flex-row items-center gap-4">
        <img
          src="/bartender_icon.png"
          alt="Bartender Icon"
          width={60}
          className="hidden md:block"
        />
        <h1 className="m-0">Triple A Bar</h1>
      </div>

      <div className="mx-auto mt-6 mb-8 w-full max-w-xl border border-gray-300 rounded-2xl shadow-md px-6 py-4 flex flex-col items-center">
        <TabSection
          tabs={[
            { id: 'drink', label: 'Drink' },
            { id: 'type', label: 'Type' },
          ]}
          currentTab={currentTab}
          setCurrentTab={setCurrentTab}
        />
        <div className="w-full max-w-md mt-2">
          <SearchBar value={query} onChange={setQuery} loading={loading} />
        </div>
      </div>

      {query.trim() && !loading && displayResults.length === 0 && (
        <p className="search-empty">No drinks found for "{query.trim()}".</p>
      )}

      <ul className="results-list">
        {displayResults.map((drink) => (
          <DrinkCard key={drink.id} drink={drink} />
        ))}
      </ul>
    </div>
  );
};
export default HomePage;
